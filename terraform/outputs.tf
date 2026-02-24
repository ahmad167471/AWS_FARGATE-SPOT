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
output "vpc_id" {
  value = aws_vpc.ahmad_vpc.id
}

output "subnet_ids" {
  value = [aws_subnet.ahmad_subnet_1.id, aws_subnet.ahmad_subnet_2.id]
}