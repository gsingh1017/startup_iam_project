provider "aws" {
    region = "ca-central-1"
}


# Developer Group
resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"
}

# Developer Group Policy
resource "aws_iam_group_policy" "developer_policy" {
  name = "developer_policy"
  group = aws_iam_group.developers.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = [
                "ec2:*",
            ],
            Effect = "Allow",
            Resource = "*"
        },
        {
            Action = [
                "s3:*",
            ],
            Effect = "Allow",
            Resource = "arn:aws:s3:::gs-application-bucket/*"
        },
        {
            Sid = "CloudWatchLogsReadOnlyAccess",
            Action = [
                "logs:Describe*",
                "logs:Get*",
                "logs:List*",
                "logs:StartQuery",
                "logs:StopQuery",
                "logs:TestMetricFilter",
                "logs:FilterLogEvents",
                "logs:StartLiveTail",
                "logs:StopLiveTail",
                "cloudwatch:GenerateQuery",
                "cloudwatch:GenerateQueryResultsSummary"
            ],
            Effect = "Allow",
            Resource = "*"
        }
    ]
  })
}

# Developer Group Membership
# Attach Developers to Developer Group
resource "aws_iam_group_membership" "developer_group_membership" {
  name = "developer-group-membership"
  users = [
    aws_iam_user.developer_1.name,
    aws_iam_user.developer_2.name,
    aws_iam_user.developer_3.name,
    aws_iam_user.developer_4.name,
  ]
  group = aws_iam_group.developers.name
}

# Developer Users
resource "aws_iam_user" "developer_1" {
  name = "developer_1"
}

resource "aws_iam_user" "developer_2" {
  name = "developer_2"
}

resource "aws_iam_user" "developer_3" {
  name = "developer_3"
}

resource "aws_iam_user" "developer_4" {
  name = "developer_4"
}



