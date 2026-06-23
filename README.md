# Installation (provisoire)
- sudo apt install jq yq (json parser et yml parser, utilisé pour le script DNS)
- créer un fichier de conf DNS cp `config.yml.example config.yml`
- renseigner les champs dans le fichier
- créer un TF var `cp infra/terraform/terraform.tfvars.example infra/terraform/terraform.tfvars`
- Lancer generate-keys.sh (à la racine) -> génère les clés SSH pour configurer les machines et se connecter en SSH
- Se rendre dans le dossier infra/terraform et lancer `terraform apply`
- Se rendre dans le dossier infra/terraform et lancer `terraform apply`
- Copier l'output dans la console "ip_publique_bastion"
- Coller l'adresse ip publique du bastion dans ~/.ssh/config pour l'hôte bastion
- Se rendre dans le dossier infra/ansible et lancer `ansible-playbook run-deploy.yml`
- lancer `./update-dns.sh` depuis la racine du projet, utiliser les outputs de la commande pour vous connecter

~/.ssh/config
```
Host bastion
HostName <change_me>
User bastion
Port 4242
IdentityFile ~/.ssh/nocodb-keys/bastion-key
IdentitiesOnly yes
StrictHostKeyChecking no
UserKnownHostsFile /dev/null

Host kong
HostName 10.0.2.44
User ubuntu
IdentityFile ~/.ssh/nocodb-keys/kong-key
IdentitiesOnly yes
ProxyJump bastion
StrictHostKeyChecking no
UserKnownHostsFile /dev/null

Host swarm_manager
HostName 10.0.2.10
User ubuntu
IdentityFile ~/.ssh/nocodb-keys/swarm_manager-key
IdentitiesOnly yes
ProxyJump bastion
StrictHostKeyChecking no
UserKnownHostsFile /dev/null

Host worker_1
HostName 10.0.2.11
User ubuntu
IdentityFile ~/.ssh/nocodb-keys/worker_1-key
IdentitiesOnly yes
ProxyJump bastion
StrictHostKeyChecking no
UserKnownHostsFile /dev/null

Host worker_2
HostName 10.0.2.12
User ubuntu
IdentityFile ~/.ssh/nocodb-keys/worker_2-key
IdentitiesOnly yes
ProxyJump bastion
StrictHostKeyChecking no
UserKnownHostsFile /dev/null

Host worker_3
HostName 10.0.2.13
User ubuntu
IdentityFile ~/.ssh/nocodb-keys/worker_3-key
IdentitiesOnly yes
ProxyJump bastion
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
```














# QuickData NocoDB 🚀
Ce projet permet de déployer une infrastructure complète sur AWS (VPC, EC2) avec une stack logicielle automatisée (Docker, NocoDB, Postgres, Gateway Kong).

# 📂 Structure du projet
Plaintext
nocodb/
├── apps/               # Configuration des services (Docker Compose, Kong)
├── infra/
│   ├── ansible/        # Automatisation de la configuration serveur
│   └── terraform/      # Infrastructure as Code (AWS)
└── README.md           # Documentation principale
🛠 Pré-requis
AWS CLI configuré avec tes accès (aws configure).

Terraform et Ansible installés localement.

Une clé SSH générée (~/.ssh/id_ed25519).

La collection Ansible AWS installée :

Bash
ansible-galaxy collection install amazon.aws
🚀 Procédure de Déploiement
1. Provisionnement de l'Infrastructure (Terraform)
L'infrastructure est isolée dans un VPC dédié à Paris (eu-west-3).

Bash
cd infra/terraform
terraform init
terraform apply -var="ssh_public_key=$(cat ~/.ssh/id_ed25519.pub)"
Note : Relevez l'adresse IP publique affichée en sortie (instance_ip).

2. Configuration et Déploiement Applicatif (Ansible)
Ansible utilise un inventaire dynamique pour cibler l'instance via ses tags AWS.

Bash
# Se placer dans le dossier ansible
cd ../ansible

# Définir le chemin de votre clé privée SSH
export ANSIBLE_SSH_KEY_PATH="~/.ssh/id_ed25519"

# Lancer le déploiement
ansible-playbook deploy.yml
🔍 Vérification et Maintenance
Statut de la plateforme
Vérifiez que les 3 containers sont en ligne (Up et healthy) :

Bash
ansible all -m shell -a "docker ps" --become
Accès Web
L'interface NocoDB est protégée par la gateway Kong. Elle est accessible sur le port 80 :

http://<VOTRE_IP_AWS>

Nettoyage (Destruction)
Pour supprimer l'intégralité des ressources AWS et éviter les frais inutiles :

Bash
cd infra/terraform
terraform destroy -var="ssh_public_key=$(cat ~/.ssh/id_ed25519.pub)"
🛡️ Sécurité (Gateway Kong)
La gateway est configurée avec les règles suivantes :

Proxying : Redirection du flux port 80 vers NocoDB.

Rate Limiting : Limite fixée à 1000 requêtes par minute pour protéger l'API.

🛠 Dépannage (Troubleshooting)
🔑 Erreur de connexion SSH (Host Key Verification)
Si vous recevez une erreur Permission denied ou Host key verification failed lors du déploiement Ansible, c'est que l'empreinte de l'IP a changé dans votre fichier known_hosts.

Solution : Nettoyez l'entrée pour l'IP concernée :

Bash
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "<VOTRE_IP_AWS>"
📡 Instance non détectée par Ansible
Si ansible-inventory --graph ne renvoie rien sous @aws_ec2, vérifiez :

Que votre instance est bien en état Running sur la console AWS.

Que vos credentials AWS sont actifs (aws sts get-caller-identity).

Que la région dans infra/ansible/aws_ec2.yml est bien eu-west-3.