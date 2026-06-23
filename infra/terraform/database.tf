resource "aws_db_instance" "nocodb_postgres" {
  engine                    = "postgres"
  engine_version            = "16.6"
  instance_class            = "db.t3.micro"
  identifier                = "nocodb-postgres"
  allocated_storage         = 20
  db_name                   = "nocodb_database"
  username                  = "nocodb_user"
  password                  = var.db_password
  multi_az                  = false
  final_snapshot_identifier = "nocodb-postgres-backup"
  skip_final_snapshot       = true
  vpc_security_group_ids    = [aws_security_group.nocodb_rds_sg.id]
  db_subnet_group_name      = aws_db_subnet_group.private_subnets.name
  availability_zone         = "${var.aws_region}a"
}