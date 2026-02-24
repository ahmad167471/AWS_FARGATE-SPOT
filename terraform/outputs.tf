output "ecr_repository_url" {
  value = aws_ecr_repository.strapi_repo.repository_url
}

output "rds_endpoint" {
  value = aws_db_instance.ahmad_db.endpoint
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ahmad_cluster.name
}
output "alb_dns_name" {
  description = "Public URL of the ALB"
  value       = aws_lb.ecs_alb.dns_name
}