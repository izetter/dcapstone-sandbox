import boto3

def lambda_handler(event, context):
	ec2 = boto3.client('ec2')
	instance_id = event['detail']['instance-id']
	addresses = ec2.describe_addresses(Filters=[{'Name': 'instance-id', 'Values': [instance_id]}])
	for address in addresses['Addresses']:
		ec2.disassociate_address(AssociationId=address['AssociationId'])
        


import boto3

def lambda_handler(event, context):
	ec2 = boto3.client('ec2')

	# Get instance ID from the event
	instance_id = event['detail']['instance-id']

	# Describe the instance to get its public IP
	response = ec2.describe_instances(InstanceIds=[instance_id])
	public_ip = response['Reservations'][0]['Instances'][0]['PublicIpAddress']

	# Describe addresses to get allocation ID
	response = ec2.describe_addresses(PublicIps=[public_ip])
	allocation_id = response['Addresses'][0]['AllocationId']

	# Disassociate address
	ec2.disassociate_address(AssociationId=allocation_id)


	import boto3

def lambda_handler(event, context):
	# Boto3 client
	ec2_client = boto3.client('ec2')
	
	# Extracting instance ID from CloudWatch Event
	instance_id = event['detail']['instance-id']
	
	# Describe the Elastic IP addresses associated with the instance
	addresses = ec2_client.describe_addresses(Filters=[{'Name': 'instance-id', 'Values': [instance_id]}])
	
	if addresses['Addresses']:
		for address in addresses['Addresses']:
			# Disassociate the Elastic IP
			ec2_client.disassociate_address(AssociationId=address['AssociationId'])
			print(f"Disassociated Elastic IP: {address['PublicIp']} from Instance: {instance_id}")
	else:
		print(f"No Elastic IPs found for Instance: {instance_id}")