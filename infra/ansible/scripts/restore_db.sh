#!/bin/bash
CONTAINER_NAME="quickdata-db"
BUCKET_NAME="{{ s3_bucket_name }}"
BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
    echo "❌ Usage: restore_db.sh <nom_fichier_s3>"
    exit 1
fi

echo "📥 Récupération du backup s3://$BUCKET_NAME/backups/$BACKUP_FILE..."
aws s3 cp s3://$BUCKET_NAME/backups/$BACKUP_FILE /tmp/restore.sql.gz

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors du téléchargement S3."
    exit 1
fi

echo "🔄 Restauration dans le container $CONTAINER_NAME (Base: root_db)..."
zcat /tmp/restore.sql.gz | docker exec -i $CONTAINER_NAME psql -U postgres -d root_db

if [ $? -eq 0 ]; then
    echo "✅ Restauration terminée avec succès."
else
    echo "❌ Échec de l'injection SQL."
fi

rm /tmp/restore.sql.gz