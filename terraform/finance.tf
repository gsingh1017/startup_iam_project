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