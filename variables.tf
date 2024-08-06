# The intent of this file is to make it easier for us to define variables, to make it a bit more modular.

variable "region-va" {
  default     = "us-east-1"
  description = "the region in which you will deploy your resources"
}

variable "virginia-a" {
  default     = "us-east-1a"
  description = "us-east-1a AZ"
}

variable "most-recent-windows-version" {
  default     = true
  description = "do we want most recent version"
}

variable "name-filter" {
  default     = "name"
  description = "what filter is this"
}

variable "name-filter-value" {
  default     = "Windows_Server-2019-English-Full-Base-*"
  description = "value of the name filter"
}

variable "virtualization-filter" {
  default     = "virtualization-type"
  description = "virtualization type filter"

}

variable "virtualization-filter-value" {
  default     = "hvm"
  description = "value of virtualization"

}

variable "owners" {
  default     = "801119661308"
  description = "owners value"

}

variable "key-algo" {
  default     = "RSA"
  description = "key type"

}

variable "windows-instance-type" {
  default     = "t2.micro"
  description = "instance type for windows instances"

}

variable "rose-court-key-pair" {
  default     = "rose-court-instance-key"
  description = "key pair for the rose court"
}

variable "get-pass-data" {
  default     = true
  description = "to get password data for this instance"
}

variable "instance-name" {
  default     = "underworld-dc"
  description = "name of our DC instance"

}

variable "member-instance-name" {
  default     = "underworld-member-1"
  description = "name of our DC instance"

}

variable "rdp-sg-name" {
  default     = "allow-admin-rdp"
  description = "name of sg"
}

variable "rdp-port" {
  default     = 3389
  description = "rdp port"

}

variable "rdp-protocol" {
  default     = "TCP"
  description = "rdp protocol"

}

variable "egress-port" {
  default     = 0
  description = "egress ports"

}

variable "egress-protocol" {
  default     = "-1"
  description = "egress protocol"

}

variable "egress-cidr-block" {
  default = "0.0.0.0/0"

}

variable "parameter-name" {
  default     = "/dev/win-dc-pass"
  description = "name of parameter"

}

variable "member-parameter-name" {
  default     = "/dev/win-member-pass"
  description = "name of parameter"

}

variable "parameter-type" {
  default = "SecureString"

}

variable "nico-param-name" {
  default = "nico-pass"

}

# variable "region-cali" {
#   description = "set the region for our aws west alias"
#   default     = "us-west-1"
# }

### vars for user data file ###
variable "ServerName" {
  description = "the name of the server"
  default     = "UnderworldDC"

}

variable "AdminSafeModePass-Param-name" {
  description = "name for param"
  default     = "AdminSafeModePassword"

}

variable "AdminSafeModePassword" {
  description = "password for when the computer is started in safe mode"
  default     = ""
  sensitive   = true

}

variable "DomainName" {
  description = "the domain name"
  default     = "underworld.net"
  sensitive   = true
}

variable "DomainNetBiosName" {
  description = "the domain name"
  default     = "UNDERWORLD"
  sensitive   = true
}

variable "ForestMode" {
  type        = string
  description = "Specifies the forest functional level for the new forest. "
  default     = "7"
}

variable "DomainMode" {
  type        = string
  description = "Specifies the domain functional level of the first domain in the creation of a new forest. "
  default     = "7"
}

#nico user
variable "UserName" {
  default     = "Nico di Angelo"
  description = "User name"
  sensitive   = true
}

variable "GivenName" {
  default     = "Nico"
  description = "Given name"
  sensitive   = true
}

variable "SurName" {
  default     = "di Angelo"
  description = "Surname"
  sensitive   = true
}

variable "SamAccountName" {
  default     = "nicodiangelo"
  description = "SamAccountName"
  sensitive   = true
}

variable "DisplayName" {
  default     = "Nico di Angelo"
  description = "Display name"
  sensitive   = true
}
