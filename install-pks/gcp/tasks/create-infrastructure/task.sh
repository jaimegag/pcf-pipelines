#!/bin/bash
set -eu

root=$PWD

# us: ops-manager-us/pcf-gcp-1.9.2.tar.gz -> ops-manager-us/pcf-gcp-1.9.2.tar.gz
pcf_opsman_bucket_path=$(grep -i 'us:.*.tar.gz' pivnet-opsmgr/*GCP.yml | cut -d' ' -f2)

# ops-manager-us/pcf-gcp-1.9.2.tar.gz -> opsman-pcf-gcp-1-9-2
pcf_opsman_image_name=$(echo $pcf_opsman_bucket_path | sed 's%.*/\(.*\).tar.gz%opsman-\1%' | sed 's/\./-/g')



if [[ ${PKS_SSL_NAME1} == "" || ${PKS_SSL_NAME1} == "null" ]]; then
  echo "Generating Self Signed Certs for ${PKS_DOMAIN} ..."
  pcf-pipelines/scripts/gen_ssl_certs.sh "${PKS_DOMAIN}"
  pcf_pks_ssl_cert=$(cat ${PKS_DOMAIN}.crt)
  pcf_pks_ssl_key=$(cat ${PKS_DOMAIN}.key)
else
  pcf_pks_ssl_cert="$PKS_SSL_CERT1"
  pcf_pks_ssl_key="$PKS_SSL_KEY1"
fi

export GOOGLE_CREDENTIALS=${GCP_SERVICE_ACCOUNT_KEY}
export GOOGLE_PROJECT=${GCP_PROJECT_ID}
export GOOGLE_REGION=${GCP_REGION}

terraform init pcf-pipelines/install-pks/gcp/terraform

terraform plan \
  -var "gcp_proj_id=${GCP_PROJECT_ID}" \
  -var "gcp_region=${GCP_REGION}" \
  -var "gcp_zone_1=${GCP_ZONE_1}" \
  -var "gcp_zone_2=${GCP_ZONE_2}" \
  -var "gcp_zone_3=${GCP_ZONE_3}" \
  -var "gcp_storage_bucket_location=${GCP_STORAGE_BUCKET_LOCATION}" \
  -var "prefix=${GCP_RESOURCE_PREFIX}" \
  -var "pcf_opsman_image_name=${pcf_opsman_image_name}" \
  -var "pcf_domain=${PCF_DOMAIN}" \
  -var "pks_domain=${PKS_DOMAIN}" \
  -var "pcf_pks_ssl_cert=${pcf_pks_ssl_cert}" \
  -var "pcf_pks_ssl_key=${pcf_pks_ssl_key}" \
  -out terraform.tfplan \
  -state terraform-state/terraform.tfstate \
  pcf-pipelines/install-pks/gcp/terraform

terraform apply \
  -state-out $root/create-infrastructure-output/terraform.tfstate \
  -parallelism=5 \
  terraform.tfplan

cd $root/create-infrastructure-output
  output_json=$(terraform output -json -state=terraform.tfstate)
  pub_ip_pks_api_lb=$(echo $output_json | jq --raw-output '.pub_ip_pks_api_lb.value')
  pub_ip_opsman=$(echo $output_json | jq --raw-output '.pub_ip_opsman.value')
cd -

echo "Please configure DNS as follows:"
echo "----------------------------------------------------------------------------------------------"
echo "*.${PKS_DOMAIN} == ${pub_ip_pks_api}"
echo "opsman.${PCF_DOMAIN} == ${pub_ip_opsman}"
echo "----------------------------------------------------------------------------------------------"
