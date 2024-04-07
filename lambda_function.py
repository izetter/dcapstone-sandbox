import boto3

def lambda_handler(event, context):
	ec2 = boto3.client('ec2')
	instance_id = event['detail']['instance-id']
	addresses = ec2.describe_addresses(Filters=[{'Name': 'instance-id', 'Values': [instance_id]}])
	for address in addresses['Addresses']:
		ec2.disassociate_address(AssociationId=address['AssociationId'])