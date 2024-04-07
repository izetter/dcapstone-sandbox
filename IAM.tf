resource "aws_iam_policy" "lambda_ec2_policy" {
	name        = "LambdaEC2ElasticIPManagementPolicy"
	description = "IAM policy for disassociating Elastic IPs from EC2 instances"

	policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
		{
			Effect   = "Allow"
			Action = [
				"ec2:DescribeAddresses",
				"ec2:AssociateAddress",
				"ec2:DisassociateAddress",
				"lambda:InvokeFunction",
				"logs:CreateLogGroup",
				"logs:CreateLogStream",
				"logs:PutLogEvents"
			]
			Resource = "*"
		},
		]
	})
}

resource "aws_iam_role" "lambda_ec2_execution_role" {
	name        = "LambdaExecutionRoleForEIPManagement"
	description = "Lambda role for EC2 EIP management"

	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
		{
			Effect = "Allow"
			Action = "sts:AssumeRole"
			Principal = {
				Service = "lambda.amazonaws.com"
			}
		},
		]
	})
}

resource "aws_iam_role_policy_attachment" "lambda_ec2_policy_attachment" {
	role       = aws_iam_role.lambda_ec2_execution_role.name
	policy_arn = aws_iam_policy.lambda_ec2_policy.arn
}
