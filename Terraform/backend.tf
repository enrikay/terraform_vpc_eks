terraform {
  backend "s3" {
    bucket = "terraform-state-enricay"
    key    = "terraform/backend"
    region = "us-east-2"
  }
}
