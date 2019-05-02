provider "aws" {
    region = "us-east-2"
}

resource "aws_elastic_beanstalk_application" "laravel-app" {
  name = "laravel-app"
}
