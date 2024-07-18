#### COMPUTE VARIABLES ####
variable "ami" {
  type        = string
  description = "Samuel Ofori AMI ID"
  default     = "ami-0283a57753b18025b"
}

variable "instance_type" {
  type        = string
  description = "Samuel Ofori Instances Type"
  default     = "t2.micro"
}



### NETWORK VARIABLES
variable "subnet" {
  type    = list(any)
  default = ["10.0.0.0/28", "10.0.0.16/28"]
}

variable "availability_zone" {
  type    = list(any)
  default = ["us-east-2a", "us-east-2b"]
}

variable "pub_cidr" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}

variable "http" {
  type    = number
  default = 80
}

variable "ssh" {
  type    = number
  default = 22
}

variable "load_balancer_type" {
  type = string
}

variable "security_group_protocol" {
  type = string
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "instance_tenancy" {
  type = string
}

variable "private_cidr" {
  type = list(any)
}

variable "http_protocol" {
  type = string
}


variable "app_name" {
  type = string
}


variable "instance_key" {
  type = string
  default = "awsUSEast2-keys"
}