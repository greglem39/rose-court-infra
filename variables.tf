# The intent of this file is to make it easier for us to define variables, to make it a bit more modular.

variable "region-va" {
  default     = "us-east-1"
  description = "the region in which you will deploy your resources"
}

variable "virginia-a" {
  default     = "us-east-1a"
  description = "us-east-1a AZ"
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

# variable "region-cali" {
#   description = "set the region for our aws west alias"
#   default     = "us-west-1"
# }
