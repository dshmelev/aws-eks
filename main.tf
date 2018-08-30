module "master" {
  source = "modules/master"
  cluster-name = "dshmelev-eks"
}

module "worker" {
  source = "modules/worker"
  cluster-name = "${module.master.cluster_name}"
  aws_security_group_cluster_id = "${module.master.aws_security_group_cluster_id}"
  vpc_id = "${module.master.vpc_id}"
  aws_eks_cluster_endpoint = "${module.master.aws_eks_cluster_endpoint}"
  aws_subnets = "${module.master.aws_subnets}"
  aws_eks_cluster_certificate_authority = "${module.master.aws_eks_cluster_certificate_authority}"
}