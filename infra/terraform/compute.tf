# ========================== AMI ==============================
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ========================== INSTANCES PUBLIQUES ==============================
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.bastionkey.key_name

  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  user_data                   = data.cloudinit_config.bastion_config.rendered
  user_data_replace_on_change = true

  source_dest_check = false

  tags = {
    Name = "bastion"
    Role = "bastion"
  }
}

resource "aws_instance" "kong" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.kongkey.key_name

  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.kong_sg.id]
  associate_public_ip_address = true

  tags = {
    Name          = "kong"
    Role          = "kong"
    RequireDocker = "true"
  }
}

# ========================== INSTANCES PRIVEES ==============================
resource "aws_instance" "swarm_manager" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.swarm_manager.key_name

  subnet_id                   = module.vpc.private_subnets[0]
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.swarm_manager_sg.id, aws_security_group.swarm_nodes_sg.id]
  private_ip                  = "10.0.2.10"

  tags = {
    Name          = "swarm_manager"
    Role          = "swarm_manager"
    RequireDocker = "true"
  }
}

resource "aws_instance" "worker_1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.worker_1.key_name

  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.swarm_nodes_sg.id]
  associate_public_ip_address = false
  private_ip                  = "10.0.2.11"

  tags = {
    Name          = "worker_1"
    Role          = "worker"
    WorkerType    = "webapp"
    RequireDocker = "true"
  }
}

resource "aws_instance" "worker_2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.worker_2.key_name

  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.swarm_nodes_sg.id]
  associate_public_ip_address = false
  private_ip                  = "10.0.2.12"

  tags = {
    Name          = "worker_2"
    Role          = "worker"
    WorkerType    = "monitoring"
    RequireDocker = "true"
  }
}

resource "aws_instance" "worker_3" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.worker_3.key_name

  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.swarm_nodes_sg.id]
  associate_public_ip_address = false
  private_ip                  = "10.0.2.13"

  tags = {
    Name          = "worker_3"
    Role          = "worker"
    WorkerType    = "webapp"
    RequireDocker = "true"
  }
}