resource "aws_instance" "my_ec2" {
	ami           = var.ami_id
	instance_type = var.instance_type
	subnet_id     = aws_subnet.my_public_subnet.id
	# key_name      = var.key_name

	tags = {
		Name = var.name_tag
	}
}