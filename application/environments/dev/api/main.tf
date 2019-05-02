provider "aws" {
    region = "us-east-2"
}

resource "aws_elastic_beanstalk_environment" "laravel-dev-api" {
  name = "laravel-dev-api"
  application = "laravel-app"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.8.7 running PHP 7.2"
  cname_prefix = "laravel-app-api"
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
    value     = "arn:aws:acm:us-east-2:765932995230:certificate/ef99422d-0d79-4666-a1ba-e16cb443a963"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "DB_DATABASE"
    value = "aws_laravel_api"
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
    namespace = "aws:autoscaling:launchconfiguration"
    name = "SecurityGroups"
    value = "sg-067406b2219a15a53"
  }
}

data "aws_route53_zone" "example_dns" {
  name = "homedup.com."
}

data "aws_elastic_beanstalk_hosted_zone" "current" {}

resource "aws_route53_record" "example_alias" {
  zone_id = "${data.aws_route53_zone.example_dns.zone_id}"
  name    = "api.${data.aws_route53_zone.example_dns.name}"
  type    = "A"
  alias {
   name    = "${aws_elastic_beanstalk_environment.laravel-dev-api.cname}"
   zone_id = "${data.aws_elastic_beanstalk_hosted_zone.current.id}"
   evaluate_target_health = true
  }
}
