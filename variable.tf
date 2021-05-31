variable "task_role_arn" {
    default = "arn:aws:iam::490827128511:role/490827128511-ECS-Service-Role"
}

variable "subnet_id" {
    type = list(string)
    default = ["subnet-4d569107"]
}

variable "vpc_id" {
    default = "vpc-00b73e7b"
}