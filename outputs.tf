output "vpc_id" {
  value = module.vpc.vpc_id
}

output "security_group_ids" {
  value = {
    "gateway" = aws_security_group.gateway.id
    "dsde"    = aws_security_group.dsde.id
  }
}
