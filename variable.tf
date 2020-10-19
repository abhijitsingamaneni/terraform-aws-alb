variable "env" {
    description = "name of the env" 
}
variable "application" {
    description = "application name"
}
variable "internal" {
    default = "false"
    description = "if the alb is internal or external"
}
variable "security_groups" {
    description = "security group in which it needs to be deployed"
}
variable "subnets" {
  description = "A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']"
  type        = list(string)
  default     = null
}
variable "port" {
    description = "target port"
}
variable "protocol" {
    description = "protocol that need to be used"
}
variable "vpc_id" {
    description = "vpc id under which we need to deploy the target group"
}
variable "certificate_arn" {
    description = "arn for the certificat that needs to be used"
}
variable "services" {
  description = "Services to deploy in this stack"
  type = map(object({
    container_image = string
    container_port = number
    min_replicas = number
    max_replicas = number
    health_check_path = string
    fargate_cpu = string
    fargate_memory = string
    host = string
  }))

  default = {
    demo = {
      container_image = "nginxdemos/hello:latest"
      container_port = 80
      min_replicas = 2
      max_replicas = 4
      health_check_path = "/"
      fargate_cpu = "256"
      fargate_memory = "512"
      host = "chat.firstopinion.com"
    }
  }
}