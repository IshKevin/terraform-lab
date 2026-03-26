variable "region" {}
variable "bucket_name" {}
variable "dynamodb_table" {}
variable "my_ip" {}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}