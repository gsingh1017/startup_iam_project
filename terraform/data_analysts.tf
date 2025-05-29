# Data Analyst Group
resource "aws_iam_group" "data_analysts" {
  name = "data_analysts"
  path = "/Users/"
}

# Data Analyst Group Policy
resource "aws_iam_group_policy" "data_analysts_group_policy" {
  name = "data_analysts_policy"
  group = aws_iam_group.data_analysts.name

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [

        # S3 Read Only Access
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:Describe*",
                "s3-object-lambda:Get*",
                "s3-object-lambda:List*"
            ],
            "Resource": "*"
        },

        # RDS Read Only Access
        {
            "Effect": "Allow",
            "Action": [
                "rds:Describe*",
                "rds:ListTagsForResource",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcs"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricData",
                "logs:DescribeLogStreams",
                "logs:GetLogEvents",
                "devops-guru:GetResourceCollection"
            ],
            "Resource": "*"
        },
        {
            "Action": [
                "devops-guru:SearchInsights",
                "devops-guru:ListAnomaliesForInsight"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "ForAllValues:StringEquals": {
                    "devops-guru:ServiceNames": [
                        "RDS"
                    ]
                },
                "Null": {
                    "devops-guru:ServiceNames": "false"
                }
            }
        }
    ]
  })
}

# Data Analysts Group Membership
# Attach Data Analysts Users to Data Analysts Group
resource "aws_iam_group_membership" "data_analysts_group_membership" {
  name = "data-analysts-group-membership"
  users = [
    aws_iam_user.data_analysts_1.name,
    aws_iam_user.data_analysts_2.name,
    aws_iam_user.data_analysts_3.name,
  ]
  group = aws_iam_group.data_analysts.name
}

# Data Analysts Users
resource "aws_iam_user" "data_analysts_1" {
  name = "data_analyst_1"
}

resource "aws_iam_user" "data_analysts_2" {
  name = "data_analyst_2"
}

resource "aws_iam_user" "data_analysts_3" {
  name = "data_analyst_3"
}