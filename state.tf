terraform {
  backend "s3" {
    bucket         = "tf-state-846656992549"
    key            = "tjc2020-livestream"
    region         = "us-east-1"
    dynamodb_table = "tf-state-locks"
  }
}

provider aws {
  region = "us-east-1"
}
