output "app_log_group_arn" {
  value = aws_cloudwatch_log_group.app.arn
}

output "ecs_log_group_arn" {
  value = aws_cloudwatch_log_group.ecs.arn
}

output "postgres_log_group_arn" {
  value = aws_cloudwatch_log_group.postgres.arn
}

output "ecs_log_group_name" {
  value = aws_cloudwatch_log_group.ecs.name
}

output "app_log_group_name" {
  value = aws_cloudwatch_log_group.app.name
}

output "postgres_log_group_name" {
  value = aws_cloudwatch_log_group.postgres.name
}