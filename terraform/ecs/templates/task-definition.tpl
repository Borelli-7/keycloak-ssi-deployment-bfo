[
    {
        "memory":1024,
        "networkMode":"awsvpc",
        "cpu":512,
        "family":"keycloak",
        "portMappings": [
            {
                "hostPort": ${host_port},
                "containerPort": ${keycloak_container_port},
                "protocol": "tcp"
            }
        ],
        "essential": true,
        "name": "${keycloak_container_name}",
        "image": "${docker_image_url}",
        "secrets": [
            {"name": "KEYCLOAK_ADMIN_PASSWORD", "valueFrom": "${keycloak_admin_password}"},
            {"name": "KC_DB_PASSWORD", "valueFrom": "${rds_password}"}
        ],
        "environment" : [
            { "name" : "KEYCLOAK_ADMIN", "value" : "${keycloak_admin_username}" },
            { "name" : "KC_DB", "value" : "postgres" },
            { "name" : "KC_DB_URL", "value" : "${database_url}" },
            { "name" : "KC_DB_DATABASE", "value" : "${database_name}" },
            { "name" : "KC_DB_USERNAME", "value" : "${rds_username}" },
            { "name" : "KC_PROXY", "value" : "${proxy_config}" },
            { "name" : "KC_HTTP_RELATIVE_PATH", "value" : "/auth" },
            { "name" : "KC_HOSTNAME_STRICT", "value" : "false"},
            { "name" : "KC_HEALTH_ENABLED", "value" : "true"}
        ],
        "command": ["start-dev"],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${app_log_group_name}",
                "awslogs-region": "${log_group_region}"
            }
        },
        "links": [
            "postgres:postgres"
        ],
        "dependsOn": [
            {
                "containerName": "postgres",
                "condition": "HEALTHY"
            }
        ],
        "healthCheck": {
            "command": [
                "CMD", "curl", "-f", "http://localhost:8080/auth/health"
            ],
            "interval": 30,
            "timeout": 10,
            "retries": 5
        }
    },
    {
        "memory":1024,
        "networkMode":"awsvpc",
        "cpu":512,
        "family":"keycloak",
        "portMappings": [
            {
                "hostPort": ${postgres_container_port},
                "containerPort": ${postgres_container_port},
                "protocol": "tcp"
            }
        ],
        "essential": true,
        "name": "postgres",
        "image": "postgres:14.4",
        "secrets": [
            { "name": "POSTGRES_PASSWORD", "valueFrom": "${rds_password}"}
        ],
        "environment" : [
            { "name" : "POSTGRES_USER", "value" : "${rds_username}" },
            { "name" : "POSTGRES_DB", "value" : "${database_name}" }
        ],
        "healthCheck": {
            "command": [
                "CMD-SHELL", "pg_isready -U ${rds_username} -d ${database_name}"
            ],
            "interval": 10,
            "timeout": 5,
            "retries": 5
        },
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${postgres_log_group_name}",
                "awslogs-region": "${log_group_region}"
            }
        }
    }
]