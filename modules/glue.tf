# Glue catalog database
resource "aws_glue_catalog_database" "data_lake_database" {
  name = "${var.name}-db"
}

# Glue crawler
resource "aws_glue_crawler" "data_lake_crawler" {
  depends_on    = [aws_s3_bucket.data_lake_bucket]
  name          = "${var.name}-crawler"
  database_name = aws_glue_catalog_database.data_lake_database.name
  role          = aws_iam_role.glue_crawler_role.arn
  s3_target {
    path = "s3://${aws_s3_bucket.data_lake_bucket.bucket}/"
  }
}

# Role
resource "aws_iam_role" "glue_crawler_role" {
  name = "${var.name}-crawler-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name = "${var.name}-glue-s3-access-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.data_lake_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.data_lake_bucket.id}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_crawler_s3_access_attachment" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.glue_crawler_role.name
}
