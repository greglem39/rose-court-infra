data "aws_ami" "windows" { # pulling latest version of windows server
  most_recent = var.most-recent-windows-version

  filter {
    name   = var.name-filter
    values = [var.name-filter-value]
  }

  filter {
    name   = var.virtualization-filter
    values = [var.virtualization-filter-value]
  }

  owners = [var.owners]

}

resource "tls_private_key" "instance-key" { #generating an RSA key
  algorithm = var.key-algo
}

resource "aws_key_pair" "rose-court-instance-key" { #creating an instance key
  key_name   = var.rose-court-key-pair
  public_key = tls_private_key.instance-key.public_key_openssh
}

# TODO:
# Create VPC with DHCP option set for houseofhades.net domain
# create IGW and attach to VPC 
# Create Subnet within VPC 
# Configure below SG to allow traffic within the subnet
# Automate EC2 instance(s) joining the domain via PowerShell

resource "aws_security_group" "allow-RDP" { # want to allow RDP from specified location
  name        = var.rdp-sg-name
  description = "to allow home RDP"

  ingress {
    description = "RDP from home"
    from_port   = var.rdp-port
    to_port     = var.rdp-port
    protocol    = var.rdp-protocol
    cidr_blocks = [var.home-ip]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["172.31.0.0/20"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  egress {
    from_port   = var.egress-port
    to_port     = var.egress-port
    protocol    = var.egress-protocol
    cidr_blocks = [var.egress-cidr-block]
  }

}

resource "aws_instance" "underworld-dc" { #using the above data for the AMI
  depends_on        = [tls_private_key.instance-key]
  ami               = data.aws_ami.windows.id
  instance_type     = var.windows-instance-type
  availability_zone = var.virginia-a
  key_name          = aws_key_pair.rose-court-instance-key.key_name
  get_password_data = var.get-pass-data
  security_groups   = [aws_security_group.allow-RDP.name]
  tags = {
    Name = var.instance-name
  }
  lifecycle {
    prevent_destroy = true # we really do not want our DC to be destroyed ...
  }
}

resource "aws_instance" "underworld-member" { #creating a member ec2 for our AD domain
  depends_on        = [tls_private_key.instance-key]
  ami               = data.aws_ami.windows.id
  instance_type     = var.windows-instance-type
  availability_zone = var.virginia-a
  key_name          = aws_key_pair.rose-court-instance-key.key_name
  get_password_data = var.get-pass-data
  security_groups   = [aws_security_group.allow-RDP.name]
  tags = {
    Name = var.member-instance-name
  }
  count = 1 # change depending on how many you want to deploy

}

resource "aws_ssm_parameter" "windows-ec2" { # storing the windows password so we don't leave it in plaintext in code
  name       = var.parameter-name
  type       = var.parameter-type
  depends_on = [aws_instance.underworld-dc]
  value      = rsadecrypt(aws_instance.underworld-dc.password_data, nonsensitive(tls_private_key.instance-key.private_key_pem))
}

resource "aws_ssm_parameter" "windows-ec2-member" { # storing the windows password so we don't leave it in plaintext in code
  name       = var.member-parameter-name
  type       = var.parameter-type
  depends_on = [aws_instance.underworld-dc]
  value      = rsadecrypt(aws_instance.underworld-member[0].password_data, nonsensitive(tls_private_key.instance-key.private_key_pem))
}

resource "aws_ssm_parameter" "nico-pass" { # storing the windows password so we don't leave it in plaintext in code
  name  = var.nico-param-name
  type  = var.parameter-type
  value = var.nico-password
}

resource "aws_ssm_parameter" "admin-safepass" { # storing the windows password so we don't leave it in plaintext in code
  name  = var.AdminSafeModePass-Param-name
  type  = var.parameter-type
  value = var.AdminSafeModePassword
}
