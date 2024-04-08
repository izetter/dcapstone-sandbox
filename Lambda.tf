resource "aws_lambda_function" "remove_eip" {
	function_name = "remove_ec2_eip"
	handler       = "lambda_function.lambda_handler"
	role          = aws_iam_role.lambda_ec2_execution_role.arn
	runtime       = "python3.12"
	filename      = "lambda_function_payload.zip"

	source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "aws_cloudwatch_event_rule" "ec2_deployed" {
	name        = "ec2_deployed"
	description = "Triggers when any EC2 instance transitions to the running state. (aka EC2 is deployed)"

	event_pattern = jsonencode({
		"source" : ["aws.ec2"],
		"detail-type" : ["EC2 Instance State-change Notification"],
		"detail" : {
		"state" : ["running"]
		}
	})
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
	rule      = aws_cloudwatch_event_rule.ec2_deployed.name
	target_id = "invoke_lambda"
	arn       = aws_lambda_function.remove_eip.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
	statement_id  = "AllowExecutionFromCloudWatch"
	action        = "lambda:InvokeFunction"
	function_name = aws_lambda_function.remove_eip.function_name
	principal     = "events.amazonaws.com"
	source_arn    = aws_cloudwatch_event_rule.ec2_deployed.arn
}
