import boto3

def disassociate_addresses(instance_id):
	ec2 = boto3.client('ec2')
	addresses = ec2.describe_addresses(Filters=[{'Name': 'instance-id', 'Values': [instance_id]}])
	for address in addresses['Addresses']:
		ec2.disassociate_address(AssociationId=address['AssociationId'])
