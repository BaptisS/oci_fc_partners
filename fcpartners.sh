#!/bin/bash
# Usage : ./fcpartners.sh update 'compartment_ocid' 
# Usage : ./fcpartners.sh partner 'partner_name'
# Usage : ./fcpartners.sh location 'region_identifier'  
case $1 in
update)
echo Updating
rm -f getfcpartners.sh
rm -f fcpartnersww.txt
wget https://raw.githubusercontent.com/BaptisS/oci_fc_partners/main/getfcpartners.sh
chmod +x getfcpartners.sh
export compocid="'$2'"
regions=$(oci iam region list --query 'data[].{name:name}' | jq -r .[].name)
for region in $regions; do ./getfcpartners.sh $region ; done
rm -f getfcpartners.sh
;;
location)
echo Find Locations by Partner
export partner="'$2'"
locationsbypartner=$(cat fcpartnersww.txt | jq -r 'select(.Partner=="'$partner'") | [.Region]')
echo $locationsbypartner | jq -r .[]
;;
partner)
echo Find Partners by Location
export location="'$2'"
partnersbylocation=$(cat fcpartnersww.txt | jq -r 'select(.Region=="'$location'") | [.Partner]')
echo $partnersbylocation | jq -r .[]
;;
*)
echo don\'t know
;;
esac
