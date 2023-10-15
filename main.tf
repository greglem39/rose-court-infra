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

  egress {
    from_port   = var.egress-port
    to_port     = var.egress-port
    protocol    = var.egress-protocol
    cidr_blocks = [var.egress-cidr-block]
  }

}

resource "aws_instance" "testWindows" { #using the above data for the AMI
  depends_on        = [tls_private_key.instance-key]
  ami               = data.aws_ami.windows.id
  instance_type     = var.windows-instance-type
  availability_zone = var.virginia-a
  key_name          = aws_key_pair.rose-court-instance-key.key_name
  get_password_data = var.get-pass-data
  security_groups   = [aws_security_group.allow-RDP.name]
  tags = {
    Name = var.dc-instance-name
  }

  # refer to https://www.microsoft.com/en-gb/industry/blog/technetuk/2016/06/08/setting-up-active-directory-via-powershell/ for AD setup
  #https://www.linkedin.com/pulse/deploying-domain-controller-ec2-instance-terraform-nicanor-foping-/

  # user_data = templatefile("userdata.tpl",

  #   {
  #     ServerName            = var.ServerName
  #     DomainName            = var.DomainName
  #     AdminSafeModePassword = var.AdminSafeModePassword
  #     ForestMode            = var.ForestMode
  #     DomainMode            = var.DomainMode
  #   }
  # )
}

resource "aws_ssm_parameter" "windows-ec2" { # storing the windows password so we don't leave it in plaintext in code
  name       = var.parameter-name
  type       = var.parameter-type
  depends_on = [aws_instance.testWindows]
  value      = rsadecrypt(aws_instance.testWindows.password_data, nonsensitive(tls_private_key.instance-key.private_key_pem))
}

resource "aws_ssm_parameter" "nico-pass" { # storing the windows password so we don't leave it in plaintext in code
  name  = var.nico-param-name
  type  = var.parameter-type
  value = var.nico-password
}
