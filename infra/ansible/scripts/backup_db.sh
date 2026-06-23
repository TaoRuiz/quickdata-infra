#!/bin/bash
CONTAINER_NAME="quickdata-db"
BUCKET_NAME="{{ s3_bucket_name }}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FILENAME="db_backup_$TIMESTAMP.sql.gz"

echo "📦 Extraction de la base de données..."
docker exec $CONTAINER_NAME pg_dumpall -U postgres > /tmp/db_dump.sql
gzip -c /tmp/db_dump.sql > /tmp/$FILENAME

echo "☁️ Envoi vers S3..."
aws s3 cp /tmp/$FILENAME s3://$BUCKET_NAME/backups/$FILENAME

rm /tmp/db_dump.sql /tmp/$FILENAME
echo "✅ Sauvegarde terminée."