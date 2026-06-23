📦 Sauvegarde : backup_db.sh
Ce script extrait l'intégralité des données de Postgres, les compresse et les propulse vers ton bucket S3 sécurisé.

Exécution manuelle (depuis ton PC) :

Bash
ansible App -m shell -a "sudo /usr/local/bin/backup_db.sh"
Automatisation : Une tâche Cron le lance chaque nuit à 3h00.

Vérification S3 : aws s3 ls s3://<votre-bucket>/backups/

🔄 Restauration : restore_db.sh
Ce script permet de récupérer un état précédent de ta base de données directement depuis le Cloud.

Usage : restore_db.sh <nom_du_fichier_sur_S3>

Exécution (depuis ton PC) :

Bash
# 1. Lister les backups disponibles
ansible App -m shell -a "aws s3 ls s3://<votre-bucket>/backups/"

# 2. Lancer la restauration d'un fichier précis
ansible App -m shell -a "sudo /usr/local/bin/restore_db.sh db_backup_20260305_075304.sql.gz"