data "template_file" "currency_exchange_service_taskdef_template" {
    template = <<EOF
    [
        {
            "name" : "$${ServiceName}",
            "image" : "$${ServiceImage}",
            "essential": true,
            "portMappings":[
                {
                    "hostPort": 8080,
                    "protocol":"tcp",
                    "containerPort":8080

                }
                
            ]
        }
    ]
    EOF
         vars = {
             ServiceName = "currency-exchange-srv-container"
             ServiceImage = "490827128511.dkr.ecr.us-east-1.amazonaws.com/currency-exchange:latest"
             
         }
}

resource "aws_ecs_task_definition" "currency_exchange_task_definition" {
    container_definitions = data.template_file.currency_exchange_service_taskdef_template.rendered
    family = "currency-exchange-task-def"
    network_mode = "awsvpc"
    task_role_arn = var.task_role_arn
    execution_role_arn = var.task_role_arn
    cpu = "512"
    memory = "1024"
    requires_compatibilities = ["FARGATE"]
}

resource "aws_ecs_service" "currency_exchange_service-def" {
    name = "currency-exchange-service"
    launch_type = "FARGATE"
    cluster = aws_ecs_cluster.ecs_cluster.name
    task_definition = aws_ecs_task_definition.currency_exchange_task_definition.arn
    desired_count ="1"
    tags = {
        author = "terraform"
    }

    network_configuration {
    subnets = var.subnet_id
    assign_public_ip = true
    security_groups = ["sg-0c012a62ccbd2cb63"]
   }
}




resource "aws_ecs_cluster" "ecs_cluster" {
    name = "currency-exchange-cluster"
    capacity_providers = ["FARGATE"]
}




