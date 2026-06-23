resource "random_id" "bucket_suffix" { byte_length = 4 }

resource "aws_s3_bucket" "backups" {
  bucket        = "quickdata-backups-${random_id.bucket_suffix.hex}"
  force_destroy = true
}

resource "aws_iam_role" "backup_role" {
  name = "backup-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" } }]
  })
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "s3-policy"
  role = aws_iam_role.backup_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        Effect = "Allow",
        Resource = [
          "${aws_s3_bucket.backups.arn}",
          "${aws_s3_bucket.backups.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "backup_profile" {
  name = "backup-profile"
  role = aws_iam_role.backup_role.name
}