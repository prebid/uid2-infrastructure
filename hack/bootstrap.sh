#!/bin/bash
# This script is intended to be run once to prepare the environment for use. Expected to be run interactively.
# The script will:
# - ask you for GCP project to use for deployment - TBD
# - allow you to purchase domain thru Google Domains
# - create terraform@ user in GCP project and grant owner permissions in this project - TBD
# - create GCS bucket for terraform state - TBD
# - configure CircleCI environment variables for project - TBD

max_domain_price=25 # USD, maximum price for domain to purchase
domain_id=uid2-0 # Creates DNS zone with this id, terraform input variable needs to be changed if this id changes

# Expected to return 0 if $domain_id zone was successfully created and purchase is okay
# Returns non-zero if failed to create managed zone or domain zone already exist, purchase is not okay
create_cloud_dns_zone() {
  gcloud dns managed-zones describe $domain_id --project $GOOGLE_PROJECT 2>/dev/null > ./zone.tmp 
  if [ "$?" -ne 0 ]
  then
    rm ./zone.tmp
    echo Creating managed zone $domain_id for $1 domain
    gcloud dns managed-zones create $domain_id --description "UID2 serving domain" --dns-name $1 --project $GOOGLE_PROJECT
    return $?
  else
    echo UID2 domain already purchased, using it.
    cat ./zone.tmp | grep dnsName && rm -f ./zone.tmp
    return 1
  fi
  
}

generate_contact_info() {

cat <<EOF > prebid-contact.yaml
allContacts:
  phoneNumber: '+1.805.5853434'
  postalAddress:
    regionCode: 'US'
    postalCode: '90045'
    administrativeArea: 'CA'
    locality: 'Los Angeles'
    addressLines: ['6100 Center Dr']
    recipients: ['Bret Gorsline']
EOF
  email=`gcloud config list --format 'value(core.account)'`
  echo "  email: $email" >> prebid-contact.yaml
}

buy_domain() {
  domain_name_and_price=`gcloud alpha domains registrations search-domains uid-$USER --project $GOOGLE_PROJECT | grep ' AVAILABLE '|sort -k 3,3|head -n 1| awk '{print $1,$3,$4}'`
  domain_name=`echo $domain_name_and_price|cut -f 1 -d ' '`
  domain_price_usd=`echo $domain_name_and_price|cut -f 2,3 -d ' '|tr -d ' '`
  domain_price_int=`echo $domain_price_float|cut -f 1 -d '.'`
  if (( $domain_price_int -gt $max_price ))
  then
    echo "Can't find cheap domain, aborting"
    exit 1
  fi
  create_cloud_dns_zone $domain_name
  if [ "$?" -eq 0 ]
  then
    echo Purchasing domain $domain_name
    generate_contact_info
    gcloud alpha domains registrations register $domain_name --project $GOOGLE_PROJECT --contact-data-from-file=prebid-contact.yaml --contact-privacy=private-contact-data --cloud-dns-zone=$domain_id  --notices=hsts-preloaded --yearly-price=$domain_price_usd
    rm -f prebid-contact.yaml
  fi
}

buy_domain
