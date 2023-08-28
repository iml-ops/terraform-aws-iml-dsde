data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_eip" "gateway" {
  domain = "vpc"
}

resource "aws_eip_association" "gateway" {
  instance_id   = aws_instance.gateway.id
  allocation_id = aws_eip.gateway.id
}

resource "random_id" "gateway_subnet" {
  byte_length = 2
}

resource "aws_instance" "gateway" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "m5n.2xlarge"

  subnet_id                   = module.vpc.private_subnets[random_id.gateway_subnet.dec % length(module.vpc.private_subnets)]
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.gateway.id]

  user_data_replace_on_change = false
  user_data_base64 = base64encode(templatefile("${path.module}/files/cloud-config.yaml", {
    boundary_cluster_id = var.boundary_cluster_id
    activation_token    = var.gateway_token
    public_ip           = aws_eip.gateway.public_ip
    tags                = jsonencode(["gateway", "dsde"])
  }))

  tags = {
    Name = "InfiniaML DSDE Gateway"
  }

  lifecycle {
    ignore_changes = [user_data_base64, subnet_id]
  }
}
