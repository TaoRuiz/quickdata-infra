module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "nocodb_network" # Nom du VPC
  cidr   = "10.0.0.0/16"    # Plage CIDR du VPC ( 65536 adresse disponible )

  azs             = ["${var.aws_region}a", "${var.aws_region}b"] # Availability Zones
  public_subnets  = ["10.0.1.0/24"]                              #, "10.0.3.0/24"]                                 # Liste des subnets publics
  private_subnets = ["10.0.2.0/24", "10.0.4.0/24"]               # Liste des subnets privés

  tags = {
    Terraform   = "true" # Ressource gérée par Terraform
    Environment = "dev"  # Tag déclaration de l'environnement
  }
}

resource "aws_db_subnet_group" "private_subnets" {
  name       = "private-subnet-group"
  subnet_ids = module.vpc.private_subnets
}