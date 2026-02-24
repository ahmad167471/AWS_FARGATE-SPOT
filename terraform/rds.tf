##########################################################
# rds.tf – Fully fixed for default VPC deployment
##########################################################

##########################################################
# DB Subnet Group
##########################################################
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "ahmad-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

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
  vpc_id      = data.aws_vpc.default.id

  # Allow ECS SG to access Postgres (5432)
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]  # Make sure ecs_sg exists
  }

  # Outbound to anywhere
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
# RDS Instance
##########################################################
resource "aws_db_instance" "ahmad_db" {
  identifier              = "ahmad-db"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "strapi"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  multi_az                = false
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  tags = {
    Name = "ahmad-db"
    Env  = "dev"
  }
}