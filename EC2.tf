resource "aws_instance" "my_eip_instance" {
	ami                    = var.ami_id
	instance_type          = var.instance_type
	subnet_id              = aws_subnet.my_public_subnet.id
	vpc_security_group_ids = [aws_security_group.sandbox_security_group.id]
	user_data              = file("${path.module}/user_data.sh")
	associate_public_ip_address = false
	tags = {
		Name = var.name_tag
	}
}

# resource "aws_eip" "my_eip" {
# 	domain   = "vpc"
# 	instance = aws_instance.my_eip_instance.id
# 	depends_on = [aws_internet_gateway.my_igw]
# }

# resource "aws_eip_association" "my_eip_ec2_association" {
# 	instance_id   = aws_instance.my_eip_instance.id
# 	allocation_id = aws_eip.my_eip.id
# }
