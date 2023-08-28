resource "aws_security_group" "gateway" {
  name        = "iml-dsde-gateway"
  description = "InfiniaML DSDE Gateway"
  vpc_id      = module.vpc.vpc_id


  ingress {
    description      = "Boundary Transport"
    from_port        = 9202
    to_port          = 9202
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Boundary SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "boundary"
  }
}

resource "aws_security_group" "dsde" {
  name        = "dsde-instance"
  description = "Allow DSDE Connections"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "DCV Port"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [var.network_cidr]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.network_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "dsde-instance"
  }

  depends_on = [
    module.vpc
  ]
}
