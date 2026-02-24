variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "image_url" {
  description = "Full ECR image URL passed from GitHub Actions"
  type        = string
}

variable "db_username" {
  description = "Database username"
  default     = "strapiuser"
}

variable "db_password" {
  description = "Database password"
  default     = "strapi123!"
}