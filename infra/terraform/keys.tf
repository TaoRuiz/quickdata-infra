resource "aws_key_pair" "kongkey" {
  key_name   = "kong-key"
  public_key = file("~/.ssh/nocodb-keys/kong-key.pub")
}

resource "aws_key_pair" "bastionkey" {
  key_name   = "bastion-key"
  public_key = file("~/.ssh/nocodb-keys/bastion-key.pub")
}

resource "aws_key_pair" "swarm_manager" {
  key_name   = "swarm_manager-key"
  public_key = file("~/.ssh/nocodb-keys/swarm_manager-key.pub")
}

resource "aws_key_pair" "worker_1" {
  key_name   = "worker_1-key"
  public_key = file("~/.ssh/nocodb-keys/worker_1-key.pub")
}

resource "aws_key_pair" "worker_2" {
  key_name   = "worker_2-key"
  public_key = file("~/.ssh/nocodb-keys/worker_2-key.pub")
}

resource "aws_key_pair" "worker_3" {
  key_name   = "worker_3-key"
  public_key = file("~/.ssh/nocodb-keys/worker_3-key.pub")
}