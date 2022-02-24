#!/bin/bash
oci network fast-connect-provider-service list --compartment-id $compocid --all --region $1 --output json --query 'data[].{Partner:"provider-name",Service:"provider-service-name",Type:"type",vlan:"supported-virtual-circuit-types"}' > $1
sed -i 's+]+],"Region":"'$1'"+g' $1
cat $1 | jq '.[] | {Partner:."Partner",Service:.Service,Region:.Region,Type:.vlan}' | jq >> fcpartnersww.txt
