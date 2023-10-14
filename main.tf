data "aws_ami" "windows" { # pulling latest version of windows server
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["801119661308"]

}

resource "tls_private_key" "instance-key" { #generating an RSA key
  algorithm = var.key-algo
}

resource "aws_key_pair" "rose-court-instance-key" { #creating an instance key
  key_name   = var.rose-court-key-pair
  public_key = tls_private_key.instance-key.public_key_openssh
}

resource "aws_security_group" "allow-RDP" { # want to allow RDP from specified location
  name        = "allow-admin-rdp"
  description = "to allow home RDP"

  ingress {
    description = "RDP from home"
    from_port   = var.rdp-port
    to_port     = var.rdp-port
    protocol    = var.rdp-protocol
    cidr_blocks = [var.home-ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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
}

resource "aws_ssm_parameter" "windows-ec2" { # storing the windows password so we don't leave it in plaintext in code
  name       = "/dev/win-ec2-pass"
  type       = "SecureString"
  depends_on = [aws_instance.testWindows]
  value      = rsadecrypt(aws_instance.testWindows.password_data, nonsensitive(tls_private_key.instance-key.private_key_pem))
}
