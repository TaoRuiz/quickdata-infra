### Utilisation

#### Register le gitlab-runner
##### Vérifier si le runner a déjà été register
```bash
cat config/gitlab-runner/config.toml
```

##### Uniquement si le runner n'a jamais été initialisé
```bash 
docker compose run --rm gitlab-runner register \
--non-interactive \
--url "https://gitlab.com" \
--token "<TOKEN>" \
--executor "docker" \
--docker-image "alpine:latest" \
--description "ci-server-vps" \
--docker-volumes /var/run/docker.sock:/var/run/docker.sock
```

##### Lancement
`docker compose up -d` 