locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.this.endpoint}
    certificate-authority-data: ${aws_eks_cluster.this.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster-name}"
KUBECONFIG
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}

output "cluster_name" {
  value = "${aws_eks_cluster.this.name}"
}

output "aws_eks_cluster_endpoint" {
  value = "${aws_eks_cluster.this.endpoint}"
}

output "aws_eks_cluster_certificate_authority" {
  value = "${aws_eks_cluster.this.certificate_authority.0.data}"
}

output "vpc_id" {
  value = "${aws_vpc.this.id}"
}

output "aws_subnets" {
  value = ["${aws_subnet.this.*.id}"]
}

output "aws_security_group_cluster_id" {
  value = "${aws_security_group.cluster.id}"
}
