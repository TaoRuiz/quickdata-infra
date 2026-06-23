🌍 Infrastructure as Code - QuickData (AWS)
Ce répertoire contient les fichiers de configuration Terraform permettant de déployer l'infrastructure cloud nécessaire à la stack QuickData sur AWS.
🏗️ Architecture de l'Infrastructure
L'infrastructure est conçue pour être légère et sécurisée, utilisant les composants suivants :
Instance EC2 : Un serveur de type t3.micro sous Ubuntu 24.04 (AMI stable).
Security Group : Un pare-feu virtuel filtrant le trafic entrant et sortant.
Key Pair : Gestion dynamique de la clé SSH pour l'accès administrateur et Ansible.
🛡️ Sécurité Réseau
Le Security Group (quickdata-app-sg) applique la politique du moindre privilège :
Port 22 (SSH) : Ouvert pour permettre l'automatisation via Ansible et la maintenance.
Port 80 (HTTP) : Ouvert pour exposer la Gateway Kong au public.
Sortie (Egress) : Autorise tout le trafic sortant pour permettre les mises à jour système (apt) et le téléchargement des images Docker.
⚙️ Variables et Configuration
Le projet utilise des variables pour éviter de stocker des informations sensibles en dur :
aws_region : Définit la zone de déploiement (par défaut : eu-central-1 Francfort).
ssh_public_key : La clé publique SSH transmise au serveur lors du provisionnement.
🚀 Utilisation

## Pré requis
En premier lieu, vous allez avoir besoin de générer une paire de clé SSH pour chaque machine.
Pour cela vous pouvez utiliser le script **`generate-keys.sh`** avec **`./generate-keys.sh`**
- Il va générer une paire de clés SSH pour chaque machine dans le path **`~/.ssh/nocodb/`**

### Pour utiliser Terraform

```bash
terraform init
```
2. Planification
Vérifiez les modifications avant l'application (en passant votre clé publique) :
```bash
terraform plan
```

3. Déploiement
Appliquez l'infrastructure :
```bash
terraform apply
```
4. Récupération de l'IP
Une fois le déploiement terminé, l'IP publique est automatiquement affichée via l'output :
```bash
terraform output instance_ip
```
🔗 Lien avec Ansible
L'instance possède un tag spécifique : Name = "QuickData-App-Server". Ce tag est crucial car il permet à l'inventaire dynamique d'Ansible (aws_ec2.yml) de cibler automatiquement ce serveur pour le déploiement applicatif sans avoir à saisir l'adresse IP manuellement.

/terraform
├── main.tf          # Bloc terraform{} + provider AWS
├── variables.tf     # Déclaration des variables (région, clés SSH...)
├── outputs.tf       # Valeurs exportées après apply (IPs, IDs...)
├── vpc.tf           # Module VPC — subnets publics/privés, AZs, route tables
├── networking.tf    # Security groups de toutes les instances
├── compute.tf       # Instances EC2 + AMI
└── keys.tf          # Paires de clés SSH (aws_key_pair)

###  🔐 Hardening du Bastion SSH

Cette partie décrit les modifications de sécurité appliquées sur le serveur bastion pour durcir l'accès SSH et réduire la surface d'attaque.

Le fichier **`bastion_custom_ssh.conf`** override la configuration SSH par défaut du bastion.
Cette config est utilisée dans **`data.tf`**.