provider "aws" {
    region = "ca-central-1"
}



# Developer Group
resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"
}

# Developer Group Policy
resource "aws_iam_group_policy" "developer_group_policy" {
  name = "developer_policy"
  group = aws_iam_group.developers.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "ec2:*",
            Effect = "Allow",
            Resource = "*"
        },
        {
            Action = "s3:*",
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
# Attach Developers Users to Developer Group
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



# Operations Group
resource "aws_iam_group" "operations" {
  name = "operations"
  path = "/users/"
}

# Opertations Group Policy
resource "aws_iam_group_policy" "operations_group_policy" {
  name = "operations_policy"
  group = aws_iam_group.operations.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "ec2:*",
            Effect = "Allow",
            Resource = "*"
        },
        {
            Action = "cloudwatch:*",
            Effect = "Allow",
            Resource = "*"
        },
        {
            Sid = "AwsSsmForSapPermissions",
            Effect = "Allow",
            Action = "ssm-sap:*"
            Resource = "arn:*:ssm-sap:*:*:*"
        },
        {
            Sid = "AwsSsmForSapServiceRoleCreationPermission",
            Effect = "Allow",
            Action = "iam:CreateServiceLinkedRole",
            Resource = "arn:aws:iam::*:role/aws-service-role/ssm-sap.amazonaws.com/AWSServiceRoleForAWSSSMForSAP",
            Condition = {
                StringEquals = {
                    "iam:AWSServiceName": "ssm-sap.amazonaws.com"
                }
            }
        },
        {
            Sid = "Ec2StartStopPermission",
            Effect = "Allow",
            Action = [
                "ec2:StartInstances",
                "ec2:StopInstances"
            ],
            Resource = "arn:aws:ec2:*:*:instance/*",
            Condition = {
                StringEqualsIgnoreCase = {
                    "ec2:resourceTag/SSMForSAPManaged": "True"
                }
            }
        },
        {
            "Sid": "CrossRegionCommunication",
            "Effect": "Allow",
            "Action": [
                "rds:CrossRegionCommunication"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Ec2",
            "Effect": "Allow",
            "Action": [
                "ec2:AllocateAddress",
                "ec2:AssociateAddress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateCoipPoolPermission",
                "ec2:CreateLocalGatewayRouteTablePermission",
                "ec2:CreateNetworkInterface",
                "ec2:CreateSecurityGroup",
                "ec2:DeleteCoipPoolPermission",
                "ec2:DeleteLocalGatewayRouteTablePermission",
                "ec2:DeleteNetworkInterface",
                "ec2:DeleteSecurityGroup",
                "ec2:DescribeAddresses",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeCoipPools",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeLocalGatewayRouteTablePermissions",
                "ec2:DescribeLocalGatewayRouteTables",
                "ec2:DescribeLocalGatewayRouteTableVpcAssociations",
                "ec2:DescribeLocalGateways",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcs",
                "ec2:DisassociateAddress",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:ModifyVpcEndpoint",
                "ec2:ReleaseAddress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:CreateVpcEndpoint",
                "ec2:DescribeVpcEndpoints",
                "ec2:DeleteVpcEndpoints",
                "ec2:AssignPrivateIpAddresses",
                "ec2:UnassignPrivateIpAddresses"
            ],
            "Resource": "*"
        },
        {
            "Sid": "CloudWatchLogs",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup"
            ],
            "Resource": [
                "arn:aws:logs:*:*:log-group:/aws/rds/*",
                "arn:aws:logs:*:*:log-group:/aws/docdb/*",
                "arn:aws:logs:*:*:log-group:/aws/neptune/*"
            ]
        },
        {
            "Sid": "CloudWatchStreams",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:log-group:/aws/rds/*:log-stream:*",
                "arn:aws:logs:*:*:log-group:/aws/docdb/*:log-stream:*",
                "arn:aws:logs:*:*:log-group:/aws/neptune/*:log-stream:*"
            ]
        },
        {
            "Sid": "Kinesis",
            "Effect": "Allow",
            "Action": [
                "kinesis:CreateStream",
                "kinesis:PutRecord",
                "kinesis:PutRecords",
                "kinesis:DescribeStream",
                "kinesis:SplitShard",
                "kinesis:MergeShards",
                "kinesis:DeleteStream",
                "kinesis:UpdateShardCount"
            ],
            "Resource": [
                "arn:aws:kinesis:*:*:stream/aws-rds-das-*"
            ]
        },
        {
            "Sid": "CloudWatch",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "cloudwatch:namespace": [
                        "AWS/DocDB",
                        "AWS/Neptune",
                        "AWS/RDS",
                        "AWS/Usage"
                    ]
                }
            }
        },
        {
            "Sid": "SecretsManagerPassword",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword"
            ],
            "Resource": "*"
        },
        {
            "Sid": "SecretsManagerSecret",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:DeleteSecret",
                "secretsmanager:DescribeSecret",
                "secretsmanager:PutSecretValue",
                "secretsmanager:RotateSecret",
                "secretsmanager:UpdateSecret",
                "secretsmanager:UpdateSecretVersionStage",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Resource": [
                "arn:aws:secretsmanager:*:*:secret:rds!*"
            ],
            "Condition": {
                "StringLike": {
                    "secretsmanager:ResourceTag/aws:secretsmanager:owningService": "rds"
                }
            }
        },
        {
            "Sid": "SecretsManagerTags",
            "Effect": "Allow",
            "Action": "secretsmanager:TagResource",
            "Resource": "arn:aws:secretsmanager:*:*:secret:rds!*",
            "Condition": {
                "ForAllValues:StringEquals": {
                    "aws:TagKeys": [
                        "aws:rds:primaryDBInstanceArn",
                        "aws:rds:primaryDBClusterArn"
                    ]
                },
                "StringLike": {
                    "secretsmanager:ResourceTag/aws:secretsmanager:owningService": "rds"
                }
            }
        }
    ]
  })
}

# Operations Group Membership
# Attach Operations Users to Operations Group
resource "aws_iam_group_membership" "operations_group_membership" {
  name = "operations-group-membership"
  users = [
    aws_iam_user.operations_1.name,
    aws_iam_user.operations_2.name,
  ]
  group = aws_iam_group.operations.name
}

# Operations Users
resource "aws_iam_user" "operations_1" {
  name = "operations_1"
}

resource "aws_iam_user" "operations_2" {
  name = "operations_2"
}
