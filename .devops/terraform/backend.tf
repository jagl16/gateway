terraform {
  backend "s3" {
    bucket         = "scaling-cloud-tfstate-erik.vandam"
    key            = "scaling-cloud.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "scaling-cloud-tfstate-lock"
  }
}
