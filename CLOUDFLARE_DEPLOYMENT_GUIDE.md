# PrimeWeb Cloudflare Deployment & Go-Live Guide

## Overview

This guide provides complete step-by-step instructions for deploying PrimeWeb with:
- **Backend:** AWS ECS Fargate with Application Load Balancer
- **Frontend:** Cloudflare Pages + CloudFront CDN
- **DNS:** Route53 with health checks
- **Monitoring:** CloudWatch dashboards and alarms

---

## Phase 1: Pre-Deployment Checklist

### 1.1 Infrastructure Prerequisites

- [ ] AWS Account with appropriate permissions
- [ ] Terraform installed (v1.0+)
- [ ] AWS CLI configured with credentials
- [ ] Docker installed locally
- [ ] Git repository pushed to GitHub
- [ ] Domain registered (rosstaxsoftware.com)

### 1.2 Credentials & Secrets

- [ ] AWS Access Key ID & Secret
- [ ] Docker Hub credentials (optional)
- [ ] GitHub Personal Access Token
- [ ] Cloudflare API token (if using Cloudflare DNS)
- [ ] Database password (strong, 16+ characters)
- [ ] Redis auth token (strong, 16+ characters)

### 1.3 Application Readiness

- [ ] Application code tested locally
- [ ] Docker image builds successfully
- [ ] Environment variables documented
- [ ] Database migrations prepared
- [ ] Health check endpoint implemented (/health)
- [ ] Logging configured

---

## Phase 2: Infrastructure Deployment

### 2.1 Deploy VPC, RDS, Redis, and RabbitMQ

```bash
cd terraform

# Initialize Terraform
terraform init

# Review plan
terraform plan -out=tfplan

# Apply configuration
terraform apply tfplan
```

**Expected time:** 15-20 minutes

**Verify:**
```bash
# Get outputs
terraform output

# Check VPC
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=primeweb-vpc"

# Check RDS
aws rds describe-db-clusters --db-cluster-identifier primeweb-cluster

# Check Redis
aws elasticache describe-replication-groups --replication-group-id primeweb
```

### 2.2 Deploy ECS, CloudFront, and Route53

```bash
# Continue with Terraform
terraform apply

# Verify ECS Cluster
aws ecs describe-clusters --clusters primeweb-cluster

# Verify CloudFront
aws cloudfront list-distributions

# Verify Route53
aws route53 list-hosted-zones
```

---

## Phase 3: Build & Push Docker Image

### 3.1 Build Docker Image

```bash
# Build image
docker build -t primeweb:latest .

# Test locally
docker-compose up -d

# Verify health
curl http://localhost:3000/health

# Stop containers
docker-compose down
```

### 3.2 Push to ECR

```bash
# Get ECR repository URL
ECR_URL=$(aws ecr describe-repositories --repository-names primeweb --query 'repositories[0].repositoryUri' --output text)

# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL

# Tag image
docker tag primeweb:latest $ECR_URL:latest
docker tag primeweb:latest $ECR_URL:v1.0.0

# Push image
docker push $ECR_URL:latest
docker push $ECR_URL:v1.0.0

# Verify
aws ecr describe-images --repository-name primeweb
```

---

## Phase 4: Configure Application Secrets

### 4.1 Store Secrets in AWS Secrets Manager

```bash
# Database URL
aws secretsmanager create-secret \
  --name primeweb/database-url \
  --secret-string "mysql://admin:PASSWORD@primeweb-cluster.xxxxx.us-east-1.rds.amazonaws.com:3306/primeweb"

# Redis URL
aws secretsmanager create-secret \
  --name primeweb/redis-url \
  --secret-string "redis://:TOKEN@primeweb-xxxxx.ng.0001.use1.cache.amazonaws.com:6379"

# RabbitMQ URL
aws secretsmanager create-secret \
  --name primeweb/rabbitmq-url \
  --secret-string "amqp://guest:guest@primeweb-rabbitmq.xxxxx.us-east-1.rds.amazonaws.com:5672"
```

### 4.2 Verify Secrets

```bash
aws secretsmanager list-secrets --filters Key=name,Values=primeweb
```

---

## Phase 5: Deploy ECS Service

### 5.1 Update Task Definition

```bash
# Get task definition
aws ecs describe-task-definition \
  --task-definition primeweb \
  --query 'taskDefinition' > task-definition.json

# Update image reference
sed -i 's|IMAGE_URL|'$ECR_URL':latest|g' task-definition.json

# Register new revision
aws ecs register-task-definition --cli-input-json file://task-definition.json
```

### 5.2 Deploy Service

```bash
# Update service
aws ecs update-service \
  --cluster primeweb-cluster \
  --service primeweb-service \
  --force-new-deployment

# Monitor deployment
aws ecs describe-services \
  --cluster primeweb-cluster \
  --services primeweb-service \
  --query 'services[0].{status:status,desiredCount:desiredCount,runningCount:runningCount}'

# Watch logs
aws logs tail /ecs/primeweb --follow
```

### 5.3 Verify Service

```bash
# Check tasks
aws ecs list-tasks --cluster primeweb-cluster

# Get task details
aws ecs describe-tasks \
  --cluster primeweb-cluster \
  --tasks <TASK_ARN>

# Check ALB health
aws elbv2 describe-target-health \
  --target-group-arn <TARGET_GROUP_ARN>
```

---

## Phase 6: Database Initialization

### 6.1 Connect to Database

```bash
# Get RDS endpoint
RDS_ENDPOINT=$(terraform output -raw rds_cluster_endpoint)

# Connect
mysql -h $RDS_ENDPOINT -u admin -p
```

### 6.2 Run Migrations

```bash
# From application container
docker exec primeweb-app npm run db:migrate

# Or via ECS task
aws ecs run-task \
  --cluster primeweb-cluster \
  --task-definition primeweb \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-xxxxx],securityGroups=[sg-xxxxx]}" \
  --overrides '{"containerOverrides":[{"name":"primeweb","command":["npm","run","db:migrate"]}]}'
```

### 6.3 Seed Data (Optional)

```bash
# Seed database
npm run db:seed
```

---

## Phase 7: DNS Configuration

### 7.1 Update Nameservers

```bash
# Get Route53 nameservers
aws route53 get-hosted-zone --id <HOSTED_ZONE_ID> \
  --query 'DelegationSet.NameServers'

# Update domain registrar with these nameservers
```

### 7.2 Verify DNS

```bash
# Check DNS propagation
nslookup primeweb.rosstaxsoftware.com

# Verify CNAME
dig primeweb.rosstaxsoftware.com

# Check health check
aws route53 get-health-check-status --health-check-id <HEALTH_CHECK_ID>
```

---

## Phase 8: SSL/TLS Certificate

### 8.1 Verify Certificate

```bash
# Check certificate status
aws acm describe-certificate \
  --certificate-arn <CERT_ARN> \
  --query 'Certificate.{Status:Status,DomainName:DomainName}'

# Verify validation
aws acm describe-certificate \
  --certificate-arn <CERT_ARN> \
  --query 'Certificate.DomainValidationOptions'
```

### 8.2 Test HTTPS

```bash
# Test HTTPS
curl -I https://primeweb.rosstaxsoftware.com

# Verify certificate
openssl s_client -connect primeweb.rosstaxsoftware.com:443
```

---

## Phase 9: CloudFront Configuration

### 9.1 Verify Distribution

```bash
# Get distribution details
aws cloudfront get-distribution \
  --id <DISTRIBUTION_ID> \
  --query 'Distribution.{Status:Status,DomainName:DomainName}'

# Check cache behaviors
aws cloudfront get-distribution-config --id <DISTRIBUTION_ID>
```

### 9.2 Test CloudFront

```bash
# Test static assets
curl -I https://primeweb.rosstaxsoftware.com/index.html

# Test API
curl -I https://primeweb.rosstaxsoftware.com/api/health

# Check cache headers
curl -I https://primeweb.rosstaxsoftware.com/index.html | grep -i cache
```

---

## Phase 10: Monitoring & Alerting

### 10.1 Verify CloudWatch Dashboards

```bash
# List dashboards
aws cloudwatch list-dashboards

# View dashboard
aws cloudwatch get-dashboard --dashboard-name primeweb-dashboard
```

### 10.2 Test Alarms

```bash
# List alarms
aws cloudwatch describe-alarms

# Verify SNS subscriptions
aws sns list-subscriptions-by-topic --topic-arn <TOPIC_ARN>
```

### 10.3 Monitor Logs

```bash
# View recent logs
aws logs tail /ecs/primeweb --follow

# Search for errors
aws logs filter-log-events \
  --log-group-name /ecs/primeweb \
  --filter-pattern "ERROR"
```

---

## Phase 11: Performance Testing

### 11.1 Load Testing

```bash
# Install Apache Bench
sudo apt-get install apache2-utils

# Run load test
ab -n 1000 -c 10 https://primeweb.rosstaxsoftware.com/

# Monitor during test
watch -n 1 'aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name TargetResponseTime \
  --dimensions Name=LoadBalancer,Value=<ALB_ARN_SUFFIX> \
  --start-time $(date -u -d "5 minutes ago" +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 60 \
  --statistics Average'
```

### 11.2 Check Metrics

```bash
# ECS CPU
aws cloudwatch get-metric-statistics \
  --namespace AWS/ECS \
  --metric-name CPUUtilization \
  --dimensions Name=ClusterName,Value=primeweb-cluster Name=ServiceName,Value=primeweb-service \
  --start-time $(date -u -d "1 hour ago" +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Average

# ALB Response Time
aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name TargetResponseTime \
  --start-time $(date -u -d "1 hour ago" +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Average
```

---

## Phase 12: Go-Live Checklist

### 12.1 Pre-Launch Verification

- [ ] Application deployed and healthy
- [ ] Database initialized and migrated
- [ ] All health checks passing
- [ ] SSL/TLS certificate valid
- [ ] DNS resolving correctly
- [ ] CloudFront caching properly
- [ ] Monitoring and alarms active
- [ ] Backup and recovery tested
- [ ] Load testing completed
- [ ] Security scan passed

### 12.2 Launch Steps

```bash
# 1. Final health check
curl https://primeweb.rosstaxsoftware.com/health

# 2. Verify all services
aws ecs describe-services \
  --cluster primeweb-cluster \
  --services primeweb-service

# 3. Check CloudWatch alarms
aws cloudwatch describe-alarms --alarm-names primeweb-*

# 4. Verify Route53 health
aws route53 get-health-check-status --health-check-id <HEALTH_CHECK_ID>

# 5. Monitor logs
aws logs tail /ecs/primeweb --follow
```

### 12.3 Post-Launch Monitoring

```bash
# Monitor for 24 hours
# Check:
# - Error rates (should be < 0.1%)
# - Response times (should be < 200ms)
# - CPU utilization (should be < 70%)
# - Memory utilization (should be < 80%)
# - Database connections (should be < 50)
# - Cache hit ratio (should be > 80%)
```

---

## Phase 13: Rollback Procedures

### 13.1 Rollback to Previous Version

```bash
# Get previous task definition
aws ecs describe-task-definition \
  --task-definition primeweb:1 \
  --query 'taskDefinition.taskDefinitionArn'

# Update service with previous version
aws ecs update-service \
  --cluster primeweb-cluster \
  --service primeweb-service \
  --task-definition primeweb:1 \
  --force-new-deployment

# Monitor rollback
aws ecs describe-services \
  --cluster primeweb-cluster \
  --services primeweb-service
```

### 13.2 Rollback Infrastructure

```bash
# If infrastructure deployment fails
terraform destroy -auto-approve

# Or rollback specific resources
terraform destroy -target aws_ecs_service.primeweb
```

---

## Phase 14: Post-Launch Operations

### 14.1 Backup Strategy

```bash
# Enable automated backups
aws rds modify-db-cluster \
  --db-cluster-identifier primeweb-cluster \
  --backup-retention-period 30 \
  --preferred-backup-window "03:00-04:00"

# Create manual snapshot
aws rds create-db-cluster-snapshot \
  --db-cluster-identifier primeweb-cluster \
  --db-cluster-snapshot-identifier primeweb-backup-$(date +%Y%m%d)
```

### 14.2 Scaling Configuration

```bash
# Auto-scaling already configured
# Monitor and adjust thresholds as needed

# View current scaling
aws application-autoscaling describe-scalable-targets \
  --service-namespace ecs
```

### 14.3 Cost Optimization

```bash
# Review costs
aws ce get-cost-and-usage \
  --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity MONTHLY \
  --metrics "UnblendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE
```

---

## Troubleshooting

### ECS Tasks Not Starting

```bash
# Check task logs
aws ecs describe-tasks \
  --cluster primeweb-cluster \
  --tasks <TASK_ARN> \
  --query 'tasks[0].{status:lastStatus,reason:stoppedReason}'

# View CloudWatch logs
aws logs tail /ecs/primeweb --follow
```

### Database Connection Issues

```bash
# Verify security group
aws ec2 describe-security-groups --group-ids <RDS_SG_ID>

# Test connection
mysql -h <RDS_ENDPOINT> -u admin -p -e "SELECT 1"
```

### DNS Resolution Issues

```bash
# Check Route53 records
aws route53 list-resource-record-sets --hosted-zone-id <ZONE_ID>

# Test DNS
nslookup primeweb.rosstaxsoftware.com
dig primeweb.rosstaxsoftware.com +trace
```

### CloudFront Caching Issues

```bash
# Invalidate cache
aws cloudfront create-invalidation \
  --distribution-id <DISTRIBUTION_ID> \
  --paths "/*"

# Check cache behavior
aws cloudfront get-distribution-config --id <DISTRIBUTION_ID>
```

---

## Support & Documentation

- **AWS ECS:** https://docs.aws.amazon.com/ecs/
- **AWS RDS:** https://docs.aws.amazon.com/rds/
- **AWS CloudFront:** https://docs.aws.amazon.com/cloudfront/
- **AWS Route53:** https://docs.aws.amazon.com/route53/
- **Terraform AWS Provider:** https://registry.terraform.io/providers/hashicorp/aws/latest

---

## Contact

**Project Owner:** Condre Dvon Ross  
**Email:** condre@rosstaxsoftware.com  
**Phone:** +1 (512) 489-6749  

---

**PrimeWeb is ready for production deployment!**
