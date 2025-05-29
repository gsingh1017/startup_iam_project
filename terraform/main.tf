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

        # EC2 Full Access
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        },

        # S3 Application Bucket Full Access
        {
            Action = [
                "s3:*",
                "s3-object-lambda:*"
            ],
            Effect = "Allow",
            Resource = "arn:aws:s3:::gs-application-bucket/*" # access only application bucket
        },

        # CloudWatch Read Only Access
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

        # EC2 Full Access
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        },

        # Systems Manager Full Access
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

        # RDS Management Access (no access to data)
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



# Finance Group
resource "aws_iam_group" "finance" {
  name = "finance"
  path = "/Users/"
}

# Finance Group Policy
resource "aws_iam_group_policy" "finance_group_policy" {
  name = "finance_policy"
  group = aws_iam_group.finance.name
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [

        # Cost Explorer Full Access   
        {
            "Sid": "CostOptimizationHubAdminAccess",
            "Effect": "Allow",
            "Action": [
                "cost-optimization-hub:ListEnrollmentStatuses",
                "cost-optimization-hub:UpdateEnrollmentStatus",
                "cost-optimization-hub:GetPreferences",
                "cost-optimization-hub:UpdatePreferences",
                "cost-optimization-hub:GetRecommendation",
                "cost-optimization-hub:ListRecommendations",
                "cost-optimization-hub:ListRecommendationSummaries"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowCreationOfServiceLinkedRoleForCostOptimizationHub",
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": [
                "arn:aws:iam::*:role/aws-service-role/cost-optimization-hub.bcm.amazonaws.com/AWSServiceRoleForCostOptimizationHub"
            ],
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "cost-optimization-hub.bcm.amazonaws.com"
                }
            }
        },
        {
            "Sid": "AllowAWSServiceAccessForCostOptimizationHub",
            "Effect": "Allow",
            "Action": [
                "organizations:EnableAWSServiceAccess"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "organizations:ServicePrincipal": [
                        "cost-optimization-hub.bcm.amazonaws.com"
                    ]
                }
            }
        },

        # AWS Budgets Full Access
        {
            "Effect": "Allow",
            "Action": [
                "budgets:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "aws-portal:ViewBilling"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "budgets.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "aws-portal:ModifyBilling",
                "ec2:DescribeInstances",
                "iam:ListGroups",
                "iam:ListPolicies",
                "iam:ListRoles",
                "iam:ListUsers",
                "organizations:ListAccounts",
                "organizations:ListOrganizationalUnitsForParent",
                "organizations:ListPolicies",
                "organizations:ListRoots",
                "rds:DescribeDBInstances",
                "sns:ListTopics"
            ],
            "Resource": "*"
        },
        
        # Resource Read Only Access
        {
            "Action": [
                "ram:Get*",
                "ram:List*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
    ]
  })
}

# Finance Group Membership
# Attach Finance User to Finance Group
resource "aws_iam_group_membership" "finance_group_membership" {
  name = "finance-group-membership"
  users = [
    aws_iam_user.finance_1.name,
  ]
  group = aws_iam_group.finance.name
}

# Finance Users
resource "aws_iam_user" "finance_1" {
  name = "finance_1"
}