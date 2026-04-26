terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ============================================================================
# VPC & NETWORKING
# ============================================================================

resource "aws_vpc" "primeweb" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "primeweb-vpc"
    Environment = var.environment
    Project     = "PrimeWeb"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "primeweb" {
  vpc_id = aws_vpc.primeweb.id

  tags = {
    Name = "primeweb-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.primeweb.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "primeweb-public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.primeweb.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "primeweb-public-subnet-2"
  }
}

# Private Subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.primeweb.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "primeweb-private-subnet-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.primeweb.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "primeweb-private-subnet-2"
  }
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_1" {
  domain = "vpc"
  tags = {
    Name = "primeweb-nat-eip-1"
  }
  depends_on = [aws_internet_gateway.primeweb]
}

resource "aws_eip" "nat_2" {
  domain = "vpc"
  tags = {
    Name = "primeweb-nat-eip-2"
  }
  depends_on = [aws_internet_gateway.primeweb]
}

# NAT Gateways
resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_1.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "primeweb-nat-gateway-1"
  }
  depends_on = [aws_internet_gateway.primeweb]
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_2.id
  subnet_id     = aws_subnet.public_2.id

  tags = {
    Name = "primeweb-nat-gateway-2"
  }
  depends_on = [aws_internet_gateway.primeweb]
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.primeweb.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.primeweb.id
  }

  tags = {
    Name = "primeweb-public-rt"
  }
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.primeweb.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }

  tags = {
    Name = "primeweb-private-rt-1"
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.primeweb.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_2.id
  }

  tags = {
    Name = "primeweb-private-rt-2"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
}

# ============================================================================
# SECURITY GROUPS
# ============================================================================

resource "aws_security_group" "alb" {
  name        = "primeweb-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.primeweb.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "primeweb-alb-sg"
  }
}

resource "aws_security_group" "app" {
  name        = "primeweb-app-sg"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.primeweb.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "primeweb-app-sg"
  }
}

resource "aws_security_group" "rds" {
  name        = "primeweb-rds-sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.primeweb.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "primeweb-rds-sg"
  }
}

resource "aws_security_group" "redis" {
  name        = "primeweb-redis-sg"
  description = "Security group for Redis"
  vpc_id      = aws_vpc.primeweb.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "primeweb-redis-sg"
  }
}

resource "aws_security_group" "rabbitmq" {
  name        = "primeweb-rabbitmq-sg"
  description = "Security group for RabbitMQ"
  vpc_id      = aws_vpc.primeweb.id

  ingress {
    from_port       = 5672
    to_port         = 5672
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  ingress {
    from_port       = 15672
    to_port         = 15672
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "primeweb-rabbitmq-sg"
  }
}

# ============================================================================
# RDS DATABASE
# ============================================================================

resource "aws_db_subnet_group" "primeweb" {
  name       = "primeweb-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "primeweb-db-subnet-group"
  }
}

resource "aws_rds_cluster" "primeweb" {
  cluster_identifier      = "primeweb-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.02.0"
  database_name           = var.db_name
  master_username         = var.db_username
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.primeweb.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  backup_retention_period = 30
  preferred_backup_window = "03:00-04:00"
  skip_final_snapshot     = false
  final_snapshot_identifier = "primeweb-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  storage_encrypted       = true
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  tags = {
    Name = "primeweb-rds-cluster"
  }
}

resource "aws_rds_cluster_instance" "primeweb_1" {
  cluster_identifier = aws_rds_cluster.primeweb.id
  instance_class     = var.db_instance_class
  engine              = aws_rds_cluster.primeweb.engine
  engine_version      = aws_rds_cluster.primeweb.engine_version
  identifier          = "primeweb-instance-1"

  tags = {
    Name = "primeweb-rds-instance-1"
  }
}

resource "aws_rds_cluster_instance" "primeweb_2" {
  cluster_identifier = aws_rds_cluster.primeweb.id
  instance_class     = var.db_instance_class
  engine              = aws_rds_cluster.primeweb.engine
  engine_version      = aws_rds_cluster.primeweb.engine_version
  identifier          = "primeweb-instance-2"

  tags = {
    Name = "primeweb-rds-instance-2"
  }
}

# ============================================================================
# ELASTICACHE REDIS
# ============================================================================

resource "aws_elasticache_subnet_group" "primeweb" {
  name       = "primeweb-redis-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "primeweb-redis-subnet-group"
  }
}

resource "aws_elasticache_replication_group" "primeweb" {
  replication_group_description = "PrimeWeb Redis Cluster"
  engine                         = "redis"
  engine_version                 = "7.0"
  node_type                      = var.redis_node_type
  num_cache_clusters             = 2
  parameter_group_name           = "default.redis7"
  port                           = 6379
  subnet_group_name              = aws_elasticache_subnet_group.primeweb.name
  security_group_ids             = [aws_security_group.redis.id]
  automatic_failover_enabled     = true
  at_rest_encryption_enabled     = true
  transit_encryption_enabled     = true
  auth_token                     = var.redis_auth_token
  multi_az_enabled               = true
  automatic_failover_enabled     = true

  tags = {
    Name = "primeweb-redis"
  }
}

# ============================================================================
# DATA SOURCES
# ============================================================================

data "aws_availability_zones" "available" {
  state = "available"
}
