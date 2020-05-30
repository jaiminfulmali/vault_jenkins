
while getopts u:r:s:p:n:f: option
do
case "${option}"
in
u) VAULT_URL=${OPTARG};;
r) ROLE_ID=${OPTARG};;
s) SECRET_ID=${OPTARG};;
p) KV_PATH=${OPTARG};;
n) KV_NAME=${OPTARG};;
f) KV_FIELD=${OPTARG};;
esac
done

curl -Lo vault.zip https://releases.hashicorp.com/vault/1.4.2/vault_1.4.2_linux_amd64.zip
unzip vault.zip
VAULT_ADDR=$VAULT_URL
ACCESS_TOKEN="$(./vault write -format=json auth/approle/login role_id=${ROLE_ID} secret_id=${SECRET_ID} | jq -r .auth.client_token)"
# ACCESS_TOKEN="$(curl -sL --request POST --data @payload.json ${VAULT_URL}/v1/auth/approle/login | jq -r .auth.client_token)"
curl -sL --header "X-Vault-Token: ${ACCESS_TOKEN}" ${VAULT_URL}/v1/${KV_PATH}/data/${KV_NAME}?version=1 | jq -r .data.data.${KV_FIELD}
