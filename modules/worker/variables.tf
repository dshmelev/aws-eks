variable "cluster-name" {
  type    = "string"
}

variable "vpc_id" {}
variable "aws_subnets" {
  type = "list"
}
variable "aws_security_group_cluster_id" {}
variable "aws_eks_cluster_certificate_authority" {}
variable "aws_eks_cluster_endpoint" {}