#!/bin/bash

NOCODB_DOMAIN=$(yq -r '.domains.nocodb' config.yml)
GRAFANA_DOMAIN=$(yq -r '.domains.grafana' config.yml)
CF_TOKEN=$(yq -r '.cloudflare.token' config.yml) #Token Cloud Flare
ZONE_ID=$(yq -r '.cloudflare.zone_id' config.yml) #Zone DNS

KONG_IP=$(cd infra/terraform && terraform output -raw ip_publique_kong)

update_or_create_record() {
  local name=$1
  local ip=$2

  # Cherche si l'enregistrement existe déjà
  RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?type=A&name=${name}" \
    -H "Authorization: Bearer ${CF_TOKEN}" \
    -H "Content-Type: application/json" | jq -r '.result[0].id')

  if [ "$RECORD_ID" == "null" ] || [ -z "$RECORD_ID" ]; then
    # Créer
    curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
      -H "Authorization: Bearer ${CF_TOKEN}" \
      -H "Content-Type: application/json" \
      --data "{\"type\":\"A\",\"name\":\"${name}\",\"content\":\"${ip}\",\"ttl\":60,\"proxied\":false}"
    echo "Créé : ${name} -> ${ip}"
  else
    # Mettre à jour
    curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" \
      -H "Authorization: Bearer ${CF_TOKEN}" \
      -H "Content-Type: application/json" \
      --data "{\"type\":\"A\",\"name\":\"${name}\",\"content\":\"${ip}\",\"ttl\":60,\"proxied\":false}"
    echo "Mis à jour : ${name} -> ${ip}"
  fi
}

for domain in "$NOCODB_DOMAIN" "$GRAFANA_DOMAIN"; do
  update_or_create_record "$domain" "$KONG_IP"
done

echo "DNS mis à jour : $KONG_IP"
echo "Noco : $NOCODB_DOMAIN"
echo "Graf : $GRAFANA_DOMAIN"