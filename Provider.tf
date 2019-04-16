provider "aws" {
  region = "us-east-2b"
  shared_credentials_file = "~/.creds"
  profile = "DEV"
  assume_role {
    role_arn    = "arn:aws:iam::<account>:rol/terraform"
  }
}
