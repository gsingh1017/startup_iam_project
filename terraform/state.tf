terraform {
  backend "s3" {
    bucket = "gs-my-terraform-state"
    key = "global/s3/terraform.tfstate"
    region = "ca-central-1"
    use_lockfile = true
  }
}