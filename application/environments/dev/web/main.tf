provider "aws" {
    region = "us-east-2"
}

resource "aws_elastic_beanstalk_environment" "laravel-web" {
  name = "laravel-web"
  application = "laravel-app"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.8.7 running PHP 7.2"
  cname_prefix = "laravel-web"
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:elasticbeanstalk:container:php:phpini"
    name = "document_root"
    value = "/public"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "VPCId"
    value = "vpc-0823dc81ea3931e57"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = "true"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = "subnet-0dda3f7d9f76c36d8,subnet-0bc07bde955773603,subnet-0f2e2e82470305006"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBSubnets"
    value = "subnet-0dda3f7d9f76c36d8,subnet-0bc07bde955773603,subnet-0f2e2e82470305006"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBScheme"
    value = "public"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "t2.micro"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "EC2KeyName"
    value = "aws_ohio"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "SecurityGroups"
    value = "sg-067406b2219a15a53"
  }
# Load balancer settings #
  setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerProtocol"
    value     = "HTTPS"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name      = "InstancePort"
    value     = "80"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name      = "SSLCertificateId"
    value     = "arn:aws:acm:us-east-2:765932995230:certificate/c3774eea-4d82-40bb-b36f-c64f026f9e7c"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerEnabled"
    value     = "true"
  }
# Env settings #
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "DB_DATABASE"
    value = "aws_laravel"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "DB_USERNAME"
    value = "awslaravel"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "DB_PASSWORD"
    value = "bingbong"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "DB_HOST"
    value = "beanstalk-abs.ckkzpudtbjwv.us-east-2.rds.amazonaws.com"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "API_URL"
    value = "https://api.homedup.com"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "OAUTH_CLIENT_ID"
    value = "2"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "OAUTH_CLIENT_SECRET"
    value = "Iy3Vphif7nvTphuWf51I5U5rhOo6v7duxrH6aYaQ"
  }
}

data "aws_route53_zone" "example_dns" {
  name = "homedup.com."
}

data "aws_elastic_beanstalk_hosted_zone" "current" {}

resource "aws_route53_record" "example_alias" {
  zone_id = "${data.aws_route53_zone.example_dns.zone_id}"
  name    = "www.${data.aws_route53_zone.example_dns.name}"
  type    = "A"
  alias {
   name    = "${aws_elastic_beanstalk_environment.laravel-web.cname}"
   zone_id = "${data.aws_elastic_beanstalk_hosted_zone.current.id}"
   evaluate_target_health = true
  }
}
