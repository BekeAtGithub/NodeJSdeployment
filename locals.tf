locals {
  bucket_name                    = "beke-bucket-demo"
  table_name                     = "beke-table-demo"
  ecr_repo_name                  = "beke-ecr-demo"
  demo_app_cluster_name          = "beke-cluster-demo"
  availability_zones             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  ecr_repo_url                   = "beke-repo-demo"
  container_port                 = 3000
  demo_app_task_name             = "beke-task-demo"
  demo_app_task_family           = "beke-task-demo"
  ecs_task_execution_role_name   = "beke-execution-demo"
  application_load_balancer_name = "beke-alb-demo"
  target_group_name              = "beke-target-demo"
  demo_app_service_name          = "beke-service-demo"
}