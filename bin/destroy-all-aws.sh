#!/usr/bin/env sh
# Basic script to destroy a bunch of EC2 and VPC stuff that cloud-nuke doesn't remove
set -ex
aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances | jq -r '.Reservations[].Instances[].InstanceId')
for id in $(aws ec2 describe-addresses | jq -r '.Addresses[].AllocationId'); do aws ec2 release-address --allocation-id $id; done
for id in $(aws ec2 describe-network-interfaces | jq -r '.NetworkInterfaces[].NetworkInterfaceId'); do aws ec2 delete-network-interface --network-interface-id $id; done
for id in $(aws ec2 describe-network-acls | jq -r '.NetworkAcls[].NetworkAclId'); do aws ec2 delete-network-acl --network-acl-id $id; done
for id in $(aws ec2 describe-subnets | jq -r '.Subnets[].SubnetId'); do aws ec2 delete-subnet --subnet-id $id; done
for id in $(aws ec2 describe-vpc-endpoints | jq -r '.VpcEndpoints[].VpcEndpointId'); do aws ec2 delete-vpc-endpoints --vpc-endpoint-id $id; done
for id in $(aws ec2 describe-vpc-peering-connections | jq -r '.VpcPeeringConnections[].VpcPeeringConnectionId'); do aws ec2 delete-vpc-peering-connection --vpc-peering-connection-id $id; done
for id in $(aws ec2 describe-nat-gateways | jq -r '.NatGateways[].NatGatewayId'); do aws ec2 delete-nat-gateway --nat-gateway-id $id; done
# Detach internet gateway first manually, can't be bothered working out the query for this.
for id in $(aws ec2 describe-internet-gateways  | jq -r '.InternetGateways[].InternetGatewayId'); do aws ec2 delete-internet-gateway --internet-gateway-id $id; done
for id in $(aws ec2 describe-security-groups | jq -r '.SecurityGroups[].GroupId'); do aws ec2 delete-security-group --group-id $id; done
for id in $(aws ec2 describe-route-tables | jq -r '.RouteTables[].RouteTableId'); do aws ec2 delete-route-table --route-table-id $id; done

