
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-south-2" #aws region code
}












resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


locals {
  lambda_funtion_zip = "out/lambda_funtion_zip"
}


# data "archive_file" "my_lambda_funtionn" {
#   type        = "zip"
#   source_file = "lambda_funtion.js"
#   output_path = "lambda_funtion_zip.zip"
# }

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "hgkj.zip"
  role          = aws_iam_role.iam_for_lambda.arn

  function_name = "terraform_lambda_fun"
  handler       = "lambda_funtion.test"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
#   source_code_hash = filebase64sha256("lambda_funtion_zip.zip")

  runtime = "nodejs16.x"

#   environment {
#     variables = {
#       foo = "bar"
#     }
#   }
}