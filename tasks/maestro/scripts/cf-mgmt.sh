function setCfMgmtPipeline() {
  foundation="${1}"
  foundation_name="${2}"

  set +e
  createCfMgmtPipeline=$(grep "BoM_cf_mgmt_version" $foundation | grep "^[^#;]")
  set -e
  if [ -z "${createCfMgmtPipeline}" ]; then
      echo "No 'cf-mgmt' config for [$foundation_name], skipping it."
  else
    cf_mgmt_version=$(grep "BoM_cfmgmt_version" $foundation | cut -d ":" -f 2 | tr -d " ")
    echo "Setting 'cf-mgmt' pipeline for foundation [$foundation_name], version [$cf_mgmt_version]"
    ./fly -t $foundation_name set-pipeline -p "$foundation_name-Cf-Mgmt" -c ./pipelines/utils/cf-mgmt-pipeline.yml -l ./common/credentials.yml -l "$foundation" -v "cf_mgmt_version=${cf_mgmt_version}" -n
  fi
}
