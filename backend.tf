terraform {
  backend "s3" {
    bucket = "prathyusha-tfstatefile"
    key    = "s3-bucket-repo/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
