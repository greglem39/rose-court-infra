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

resource "aws_instance" "testWindows" { #using the above data for the AMI
  ami               = data.aws_ami.windows.id
  instance_type     = var.windows-instance-type
  availability_zone = var.virginia-a
  key_name          = var.rose-court-key-pair
  get_password_data = var.get-pass-data
}
