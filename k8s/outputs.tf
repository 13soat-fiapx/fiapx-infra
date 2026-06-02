output "environment" {
  value = var.environment
}

output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "nlb_dns_name" {
  value = aws_lb.eks_nlb.dns_name
}

output "nlb_listener_arn" {
  value = aws_lb_listener.nlb_listener_http.arn
}

output "vpc_link_security_group_id" {
  value = aws_security_group.vpc_link.id
}
