variable "REGION" {
  default = "us-east-2"
}
variable "ZONE1" {
  default = "us-east-2a"
}

variable "ZONE2" {
  default = "us-east-2b"
}

variable "TAGS" {
  default = {
    Name    = "money-pal-cluster"
    Project = "money-pal app"
    script  = "terraform"
  }
}
