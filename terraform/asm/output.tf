output "keycloak_admin_password" {
  value = data.aws_secretsmanager_secret_version.keycloak-admin.arn
  sensitive = true
}

output "postgres_db_password" {
  value = data.aws_secretsmanager_secret_version.postgres-user.arn
  sensitive = true
}