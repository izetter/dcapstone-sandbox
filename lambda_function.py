from disassociate_eip_addresses import disassociate_addresses

def lambda_handler(event, context):
	instance_id = event['detail']['instance-id']
	disassociate_addresses(instance_id)
