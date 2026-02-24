variable "region" {
  default = "us-east-1"
}

variable "image_url" {
  description = "ECR image URL passed from GitHub Actions"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for ECS deployment"
  type        = string
}

variable "db_username" {
  default = "strapiuser"
}

variable "db_password" {
  default = "strapi123!"
}