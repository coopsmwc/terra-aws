provider "aws" {
    region = "us-east-2"
}

resource "aws_codepipeline" "web-pipeline" {
  name     = "web-pipeline"
  role_arn = "arn:aws:iam::765932995230:role/AWS-CodePipeline-Service"

  artifact_store {
    location = "codepipeline-us-east-2-127224142257"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["webSource"]

      configuration {
        Owner      = "coopsmwc"
        Repo       = "aws_laravel_test"
        Branch     = "develop"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "WebBuild"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["webSource"]
      output_artifacts = ["webBuilt"]
      version = "1"

      configuration {
        ProjectName = "code-build-1"
      }
    }
  }

  stage {
    name = "ConfirmDeployment"

    action {
      name = "ConfirmDeployment"
      category = "Approval"
      owner = "AWS"
      provider = "Manual"
      input_artifacts = []
      output_artifacts = []
      version = "1"

      configuration {}
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "webDeploy"
      category = "Deploy"
      owner = "AWS"
      provider = "ElasticBeanstalk"
      input_artifacts = ["webBuilt"]
      version = "1"

      configuration {
        ApplicationName = "laravel-app"
        EnvironmentName = "laravel-web"
      }
    }
  }
}
