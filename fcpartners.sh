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
echo "We're currently updating the list of FC Partners available worldwide. (Please be patient)" 
regions=$(oci iam region list --query 'data[].{name:name}' | jq -r .[].name)
for region in $regions; do ./getfcpartners.sh $region $2; done
rm -f getfcpartners.sh
rm -f ocifcpartners_*
echo "Usage : ./fcpartners.sh update 'compartment_ocid'" 
echo "Usage : ./fcpartners.sh partner 'partner_name'"
echo "Usage : ./fcpartners.sh location 'region_identifier'" 
;;

partner)
echo FastConnect Partner:"'$2'" is available in the following OCI regions :
export partner=$2
locationsbypartner=$(cat fcpartnersww.txt | jq -r 'select(.Partner=="'"$partner"'") | [.Region]')
echo $locationsbypartner | jq -r .[] | uniq | sort
;;

location)
echo The following FastConnect Partners are available in OCI Region : "'$2'"
export location=$2
partnersbylocation=$(cat fcpartnersww.txt | jq -r 'select(.Region=="'"$location"'") | [.Partner]')
echo $partnersbylocation | jq -r .[] | uniq | sort
;;

list)
echo "List all FastConnect partners available worldwide"
cat fcpartnersww.txt | jq -r [.Partner] > fcpartnerslist.txt
sort fcpartnerslist.txt | uniq -c
rm -f fcpartnerslist.txt
;;

*)
echo don\'t know
;;
esac
