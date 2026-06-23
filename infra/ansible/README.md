Ce dossier contient toute l'intelligence de déploiement pour envoyer notre stack NocoDB + Kong sur AWS sans aucune saisie manuelle d'IP.

### 📁 Structure des fichiers
ansible.cfg : Le fichier de configuration d'Ansible. Il active le plugin AWS EC2 et désactive la vérification stricte des clés SSH (utile pour les IPs dynamiques d'AWS).
aws_ec2.yml : L'inventaire dynamique. Au lieu d'écrire l'IP, ce fichier interroge l'API AWS pour trouver les instances portant le tag Name: QuickData-App-Server.
deploy.yml : Le playbook qui contient la suite d'instructions (Installation Docker, transfert de fichiers, lancement des containers).


> [!WARNING]
> ⚠️ — La config du bastion se fait maintenant directement depuis le Terraform. Le bastion n'a plus de fichier Ansible dédié.


### 🛠 Pré-requis
Avoir Ansible installé localement.

Avoir les credentials AWS configurés (via aws configure ou variables d'environnement).

Avoir installé la collection AWS pour Ansible :

```bash
ansible-galaxy collection install amazon.aws
```

## 🚀 Procédure de déploiement
### 1. Définir la clé SSH (Dynamique)
> [!WARNING]
> ⚠️ **OBSOLÈTE** — Ce point n'est plus d'actualité, cette commande n'est plus nécessaire.

```bash
export ANSIBLE_SSH_KEY_PATH="~/.ssh/id_ed25519"
```

### 2. Vérifier que l'instance est détectée
(opt) Il peut être nécessaire d'installer les dépendances manquantes :
```bash
pipx inject ansible boto3 botocore
```

### 3. Définir le mot de passe de la base de données de NocoDB (RDS)
```bash
export TF_VAR_db_password="Password"
```

Lance cette commande pour voir si Ansible trouve bien ton serveur AWS grâce aux tags :
```bash
ansible-inventory -i ./aws_ec2.yml --graph
```
### 4. Lancer le déploiement
Depuis le dossier ansible, exécute le playbook :

```bash
ansible-playbook ./run-deploy.yml -i aws_ec2.yml
```
🔍 Commandes de maintenance
Vérifier le statut des containers :

```bash
ansible all -m shell -a "docker ps" --become
Redémarrer uniquement la Gateway (Kong) après une modif de config :
```

```bash
ansible all -m shell -a "cd /opt/quickdata/docker-compose && docker compose restart kong" --become
```


Debug :
pipx inject ansible boto3 botocore

### Déploiement auto
ansible-playbook run-deploy.yml