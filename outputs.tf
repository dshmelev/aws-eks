output "kubeconfig" {
  value = "${module.master.kubeconfig}"
}

output "config-map-aws-auth" {
  value = "${module.worker.config-map-aws-auth}"
}