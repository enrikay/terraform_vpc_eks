resource "aws_iam_role_policy" "policy_name"{
          name = "role_name"
          role = aws_iam_role.role_name.id
          policy = jsonencode({
          Version = "2012-10-17"
          Statement = [{
                    "Sid": "Statement1",
                    "Effect": "Allow",
                    Action = [
                          "ec2-instance-connect:SendSerialConsoleSSHPublicKey",
                          "ec2-instance-connect:SendSSHPublicKey",
                          "autoscaling:ExecutePolicy",
                          "s3:CreateBucket",
                          "s3:DeleteBucket"
                    ]
                    "Resource": ["*" ]
          }]
          })
}

resource "aws_iam_role" "role_name" {
        name = "role_name"
        assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
                "Effect": "Allow"
                "Principal": {
                          "Service": "ec2.amazonaws.com"
                }
                "Action": "sts:AssumeRole"
        }]
        })
}