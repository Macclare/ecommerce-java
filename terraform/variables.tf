variable "aws_region" {
  description = "AWS region to deploy the EKS cluster"
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "cluster_name" {
  default = "ecommerce-cluster"
}

variable "desired_capacity" {
  default = 2
}

variable "max_capacity" {
  default = 3
}

variable "min_capacity" {
  default = 1
}

variable "instance_type" {
  default = "t3.medium"
}
