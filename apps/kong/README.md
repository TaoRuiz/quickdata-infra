# QuickData Stack - Orchestration Docker

Ce dossier contient la définition des services applicatifs et de la couche de sécurité.

## 🏗️ Architecture
La stack est composée de trois services orchestrés via Docker Compose :

1. **PostgreSQL** : Base de données principale, isolée dans le réseau `backend`.
2. **NocoDB** : Application métier, interface de gestion de données.
3. **Kong Gateway** : Point d'entrée unique de l'infrastructure.

## 🛡️ Sécurité
L'isolation est assurée par deux réseaux Docker distincts :
- **Network `backend`** : Communication interne entre NocoDB et PostgreSQL. La base de données n'est pas exposée sur le serveur hôte.
- **Network `frontend`** : Communication entre Kong et NocoDB.

### Protection API (Rate Limiting)
Kong agit comme une sentinelle. Le fichier `kong.yml` configure le plugin `rate-limiting` :
- **Limite** : 1000 requêtes / minute.
- **Raison** : Protection contre les attaques par force brute et le scraping intensif, tout en permettant le chargement fluide des nombreux assets de l'interface NocoDB.

## 🚀 Utilisation locale
Pour lancer la stack manuellement (hors Ansible) :
```bash
docker compose up -d