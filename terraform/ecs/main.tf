resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "main" {
  family                = var.ecs_task_family
  execution_role_arn    = var.ecs_password_policy_role_arn
  container_definitions = templatefile(
    "${path.module}/templates/task-definition.tpl",
    {
      keycloak_container_name = var.keycloak_container_name
      docker_image_url        = var.docker_image_url
      log_group_region        = var.aws_region
      app_log_group_name      = var.app_log_group_name
      postgres_log_group_name = var.postgres_log_group_name
      keycloak_container_port = var.keycloak_container_port
      postgres_container_port = var.postgres_container_port
      host_port               = var.docker_host_port
      keycloak_admin_username = var.keycloak_admin_username
      keycloak_admin_password = var.keycloak_admin_password
      database_url            = var.database_url
      database_name           = var.database_name
      rds_username            = var.rds_username
      rds_password            = var.rds_password
      proxy_config            = var.proxy_config
    }
  )
}

resource "aws_ecs_service" "main" {
  name            = "ecs_service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.ecs_desired_instances
  iam_role        = var.ecs_iam_role_name

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.keycloak_container_name
    container_port   = var.keycloak_container_port
  }

  depends_on = [
    var.ecs_service_iam_role_policy
  ]
}
