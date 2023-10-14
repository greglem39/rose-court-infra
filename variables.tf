# The intent of this file is to make it easier for us to define variables, to make it a bit more modular.
variable "region-va" {
  default     = "us-east-1"
  description = "the region in which you will deploy your resources"
}

variable "virginia-a" {
  default     = "us-east-1a"
  description = "us-east-1a AZ"
}

# variable "region-cali" {
#   description = "set the region for our aws west alias"
#   default     = "us-west-1"
# }
