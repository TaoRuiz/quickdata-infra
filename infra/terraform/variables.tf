variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "db_password" {
  description = "Mot de passe de la base de données"
  type        = string
  sensitive   = true
}