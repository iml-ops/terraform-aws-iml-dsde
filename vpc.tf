locals {
  networks        = cidrsubnets(var.network_cidr, 1, 1)
  private_subnets = [local.networks[0]] # cidrsubnets(local.networks[0], [for i in local.azs : 0]...)
  public_subnets  = [local.networks[1]] # cidrsubnets(local.networks[1], [for i in local.azs : 0]...)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.network_cidr
  azs  = local.azs

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  private_subnet_tags = {
    "iml/isolation" = "dsde"
    "iml/partition" = "private"
  }

  public_subnet_tags = {
    "iml/isolation" = "dsde"
    "iml/partition" = "public"
  }
}
