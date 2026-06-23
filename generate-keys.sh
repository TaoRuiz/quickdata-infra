#!/usr/bin/env bash

DIR="$HOME/.ssh/nocodb-keys"

if [ ! -d "$DIR" ]; then
    mkdir -p "$DIR"
    echo "Dossier créé : $DIR"
else
    echo "Le dossier existe déjà : $DIR"
    rm -f "$DIR"/*
    echo "Dossier vidé : $DIR"
fi

ssh-keygen -t ed25519 -f "$DIR/bastion-key" -N ""
ssh-keygen -t ed25519 -f "$DIR/kong-key" -N ""
ssh-keygen -t ed25519 -f "$DIR/swarm_manager-key" -N ""
ssh-keygen -t ed25519 -f "$DIR/worker_1-key" -N ""
ssh-keygen -t ed25519 -f "$DIR/worker_2-key" -N ""
ssh-keygen -t ed25519 -f "$DIR/worker_3-key" -N ""
