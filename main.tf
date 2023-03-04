terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "lb" {
  name = "rocky"
  path = "/system/"

  tags = {
    tag-key = "music"
  }
}

resource "aws_iam_user_policy" "lb2" {
  name   = "administrator_access"
  user   = aws_iam_user.lb.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_group" "musicians" {
  name = "musicians"
  path = "/users/"

}

resource "aws_iam_group_membership" "team" {
  name = "team1"

  users = [
    aws_iam_user.lb.name
  ]

  group = aws_iam_group.musicians.name
}

resource "aws_iam_group_policy" "lb3" {
  name  = "administrator_access"
  group = aws_iam_group.musicians.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}