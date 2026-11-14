module "my_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 6.0"

  name            = "tf-vpc-sg"
  use_name_prefix = false
  vpc_id          = module.my_vpc.vpc_id

  ingress_rules = {
    http = {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
    }

    ssh = {
      cidr_ipv4   = "${trimspace(data.http.myip_v4.response_body)}/32"
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
    }
  }

  egress_rules = {
    all = { cidr_ipv4 = "0.0.0.0/0", ip_protocol = "-1" }
  }

  tags = { Name = "tf-vpc-sg" }
}

# IPv4-only endpoint: returns a plain IPv4 address regardless of whether the
# host prefers IPv6 (ifconfig.me is dual-stack and may answer with an IPv6).
data "http" "myip_v4" {
  url = "https://ipv4.icanhazip.com"
}

