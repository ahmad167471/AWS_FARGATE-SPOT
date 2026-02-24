##########################################################
# rds.tf – Fully Fixed for New VPC Deployment
##########################################################

##########################################################
# DB Subnet Group (MUST use PRIVATE subnets)
##########################################################
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "ahmad-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Name = "ahmad-db-subnet-group"
    Env  = "dev"
  }
}

##########################################################
# Security Group for RDS
##########################################################
resource "aws_security_group" "rds_sg" {
  name        = "ahmad-rds-sg"
  description = "Allow ECS to connect to RDS"
  vpc_id      = aws_vpc.ahmad_vpc.id

  # Allow ECS security group to access PostgreSQL
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ahmad-rds-sg"
    Env  = "dev"
  }
}

##########################################################
# RDS PostgreSQL Instance
##########################################################
resource "aws_db_instance" "ahmad_db" {
  identifier = "ahmad-db"

  engine         = "postgres"
  engine_version = "15.5"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "strapi"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible     = false
  multi_az                = false
  backup_retention_period = 7
  deletion_protection     = false
  skip_final_snapshot     = true

  tags = {
    Name = "ahmad-db"
    Env  = "dev"
  }

  depends_on = [
    aws_db_subnet_group.db_subnet_group
  ]
}
