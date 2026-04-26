# PrimeWeb AWS Infrastructure Setup Guide

## Overview

This guide provides complete setup instructions for deploying PrimeWeb infrastructure on AWS using Terraform.

**Infrastructure Components:**
- ✅ VPC with public/private subnets across 2 availability zones
- ✅ RDS Aurora MySQL cluster (multi-AZ, encrypted)
- ✅ ElastiCache Redis cluster (multi-AZ, encrypted, auth-enabled)
- ✅ RabbitMQ (prepared for deployment)
- ✅ Security groups with least-privilege access
- ✅ NAT gateways for private subnet egress
- ✅ Internet gateway for public subnet ingress

---

## Prerequisites

1. **AWS Account** - Active AWS account with appropriate permissions
2. **Terraform** - Version 1.0 or higher
3. **AWS CLI** - Configured with credentials
4. **Git** - For version control

### Install Terraform

```bash
# macOS (Homebrew)
brew install terraform

# Linux
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

### Verify Installation

```bash
terraform --version
aws --version
```

---

## Step 1: Prepare Configuration

### 1.1 Copy Example Variables

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

### 1.2 Edit terraform.tfvars

```bash
nano terraform.tfvars
```

**Update these values:**

```hcl
# AWS Configuration
aws_region  = "us-east-1"  # Change if needed
environment = "production"

# VPC Configuration (keep defaults or customize)
vpc_cidr                = "10.0.0.0/16"
public_subnet_1_cidr    = "10.0.1.0/24"
public_subnet_2_cidr    = "10.0.2.0/24"
private_subnet_1_cidr   = "10.0.10.0/24"
private_subnet_2_cidr   = "10.0.11.0/24"

# RDS Configuration
db_name              = "primeweb"
db_username          = "admin"
db_password          = "YOUR_SECURE_PASSWORD_HERE"  # ⚠️ CHANGE THIS!
db_instance_class    = "db.t3.medium"  # Adjust for production

# Redis Configuration
redis_node_type   = "cache.t3.medium"  # Adjust for production
redis_auth_token  = "YOUR_SECURE_TOKEN_HERE"  # ⚠️ CHANGE THIS!
```

**Security Best Practices:**

- Use strong passwords (minimum 16 characters)
- Include uppercase, lowercase, numbers, and special characters
- Never commit `terraform.tfvars` to version control
- Use AWS Secrets Manager for production credentials

---

## Step 2: Initialize Terraform

```bash
cd terraform
terraform init
```

**Output:**
```
Terraform has been successfully configured!
```

---

## Step 3: Plan Infrastructure

```bash
terraform plan -out=tfplan
```

**Review the plan:**
- Check all resources to be created
- Verify security group rules
- Confirm database configuration
- Ensure correct availability zones

---

## Step 4: Apply Configuration

```bash
terraform apply tfplan
```

**Expected time:** 15-20 minutes

**Monitor progress:**
- VPC creation: ~1 minute
- RDS cluster creation: ~10-15 minutes
- Redis cluster creation: ~5 minutes
- Security groups: ~1 minute

---

## Step 5: Verify Deployment

### 5.1 Check Terraform Outputs

```bash
terraform output
```

**Expected outputs:**
```
vpc_id = "vpc-xxxxx"
rds_cluster_endpoint = "primeweb-cluster.xxxxx.us-east-1.rds.amazonaws.com"
redis_endpoint = "primeweb-xxxxx.ng.0001.use1.cache.amazonaws.com"
```

### 5.2 Verify in AWS Console

**VPC:**
- Go to VPC Dashboard
- Verify VPC created with correct CIDR block
- Check subnets in both availability zones
- Verify NAT gateways and internet gateway

**RDS:**
- Go to RDS Dashboard
- Verify Aurora cluster is "Available"
- Check 2 instances in different AZs
- Verify encryption enabled
- Check backup retention (30 days)

**ElastiCache:**
- Go to ElastiCache Dashboard
- Verify Redis cluster is "Available"
- Check replication group with 2 nodes
- Verify encryption enabled
- Check auth token configured

---

## Step 6: Connect to Database

### 6.1 Get Connection Details

```bash
# RDS Endpoint
terraform output rds_cluster_endpoint

# Redis Endpoint
terraform output redis_endpoint
```

### 6.2 Test RDS Connection

```bash
# Install MySQL client
sudo apt-get install mysql-client

# Connect to RDS
mysql -h <RDS_ENDPOINT> -u admin -p
# Enter password when prompted

# Verify connection
SHOW DATABASES;
```

### 6.3 Test Redis Connection

```bash
# Install Redis client
sudo apt-get install redis-tools

# Connect to Redis
redis-cli -h <REDIS_ENDPOINT> -p 6379 --tls -a <AUTH_TOKEN>

# Verify connection
PING
```

---

## Step 7: Configure Application

### 7.1 Environment Variables

Create `.env` file in application root:

```bash
# Database
DATABASE_URL=mysql://admin:PASSWORD@<RDS_ENDPOINT>:3306/primeweb

# Redis
REDIS_URL=redis://:TOKEN@<REDIS_ENDPOINT>:6379

# RabbitMQ (configure separately)
RABBITMQ_URL=amqp://guest:guest@<RABBITMQ_ENDPOINT>:5672
```

### 7.2 Initialize Database

```bash
# Run migrations
npm run db:migrate

# Seed data (if applicable)
npm run db:seed
```

---

## Step 8: Deploy Application

### 8.1 Using ECS/Fargate

```bash
# Build Docker image
docker build -t primeweb:latest .

# Push to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com

docker tag primeweb:latest <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/primeweb:latest
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/primeweb:latest
```

### 8.2 Using EC2

```bash
# SSH into EC2 instance
ssh -i <KEY_PAIR> ec2-user@<INSTANCE_IP>

# Clone repository
git clone https://github.com/rosstaxprep/taxplatform.git
cd taxplatform

# Install dependencies
npm install

# Start application
npm start
```

---

## Monitoring & Maintenance

### CloudWatch Monitoring

```bash
# View RDS metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name CPUUtilization \
  --dimensions Name=DBClusterIdentifier,Value=primeweb-cluster \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-01-02T00:00:00Z \
  --period 300 \
  --statistics Average
```

### Backup & Recovery

```bash
# Create manual snapshot
aws rds create-db-cluster-snapshot \
  --db-cluster-identifier primeweb-cluster \
  --db-cluster-snapshot-identifier primeweb-backup-$(date +%Y%m%d)

# List snapshots
aws rds describe-db-cluster-snapshots \
  --db-cluster-identifier primeweb-cluster
```

### Scaling

```bash
# Scale RDS instance class
terraform apply -var="db_instance_class=db.t3.large"

# Scale Redis node type
terraform apply -var="redis_node_type=cache.t3.large"
```

---

## Troubleshooting

### RDS Connection Issues

```bash
# Check security group
aws ec2 describe-security-groups --group-ids <RDS_SG_ID>

# Verify subnet group
aws rds describe-db-subnet-groups --db-subnet-group-name primeweb-db-subnet-group
```

### Redis Connection Issues

```bash
# Check ElastiCache cluster status
aws elasticache describe-replication-groups --replication-group-id primeweb

# Verify security group
aws ec2 describe-security-groups --group-ids <REDIS_SG_ID>
```

### Terraform Issues

```bash
# Validate configuration
terraform validate

# Format code
terraform fmt

# Show current state
terraform show

# Refresh state
terraform refresh
```

---

## Cleanup (Destroy Infrastructure)

⚠️ **WARNING:** This will delete all resources including databases!

```bash
# Plan destruction
terraform plan -destroy

# Destroy infrastructure
terraform destroy
```

**Confirm by typing:** `yes`

---

## Cost Estimation

### Monthly Costs (Approximate)

| Service | Instance Type | Estimated Cost |
|---------|---------------|----------------|
| RDS Aurora MySQL | db.t3.medium | $150-200 |
| ElastiCache Redis | cache.t3.medium | $80-100 |
| NAT Gateway | 2x | $60-80 |
| Data Transfer | Varies | $50-100 |
| **Total** | | **$340-480/month** |

**Cost Optimization:**
- Use Reserved Instances for 30-50% savings
- Enable auto-scaling for variable workloads
- Use spot instances for non-critical workloads
- Monitor CloudWatch for unused resources

---

## Security Best Practices

1. **Encryption**
   - ✅ RDS: Encrypted at rest (AES-256)
   - ✅ Redis: Encrypted in transit (TLS)
   - ✅ Database passwords: Rotated regularly

2. **Access Control**
   - ✅ Security groups: Least privilege
   - ✅ IAM roles: Minimal permissions
   - ✅ VPC: Private subnets for databases

3. **Monitoring**
   - ✅ CloudWatch logs enabled
   - ✅ Enhanced monitoring active
   - ✅ Alerts configured

4. **Backup & Recovery**
   - ✅ Automated backups: 30 days
   - ✅ Multi-AZ deployment
   - ✅ Point-in-time recovery

---

## Support & Documentation

- **Terraform Docs:** https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- **AWS RDS:** https://docs.aws.amazon.com/rds/
- **AWS ElastiCache:** https://docs.aws.amazon.com/elasticache/
- **Terraform AWS Provider:** https://registry.terraform.io/providers/hashicorp/aws/latest

---

## Next Steps

1. ✅ Deploy infrastructure using Terraform
2. ✅ Configure application environment variables
3. ✅ Initialize database and run migrations
4. ✅ Deploy application to ECS/EC2
5. ✅ Set up monitoring and alerts
6. ✅ Configure backup and disaster recovery
7. ✅ Test failover and recovery procedures

---

**Infrastructure Setup Complete!**

Your PrimeWeb infrastructure is now ready for production deployment.
