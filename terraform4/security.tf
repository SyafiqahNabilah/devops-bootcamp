module "my_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  name            = "tf4-rackula-sg"
  use_name_prefix = false
  description     = "Allow access to the Rackula web UI"
  vpc_id          = module.my_vpc.vpc_id

  ingress_rules = {
    rackula = {
      description = "Rackula web UI"
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "tcp"
      from_port   = 8080
      to_port     = 8080
    }
  }

  egress_rules = {
    all = { cidr_ipv4 = "0.0.0.0/0", ip_protocol = "-1" }
  }

  tags = { Name = "tf4-rackula-sg" }
}
