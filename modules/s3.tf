data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "replication" {
  name               = "${var.name}-role-replication"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "replication" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]

    resources = [aws_s3_bucket.data_lake_bucket.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]

    resources = ["${aws_s3_bucket.data_lake_bucket.arn}/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
    ]

    resources = ["${aws_s3_bucket.data_lake_bucket_replica.arn}/*"]
  }
}

resource "aws_iam_policy" "replication" {
  name   = "${var.name}-policy-replication"
  policy = data.aws_iam_policy_document.replication.json
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}


# S3 bucket Replica
resource "aws_s3_bucket" "data_lake_bucket_replica" {
  bucket = "${var.name}-bucket-replica"
  acl    = "private"

  lifecycle_rule {
    id      = "${var.name}-replica-rule"
    prefix  = ""
    enabled = true

    expiration {
      days = 1825
    }
  }

  versioning {
    enabled = true
  }
}

# S3 bucket Data
resource "aws_s3_bucket" "data_lake_bucket" {
  bucket = "${var.name}-bucket-data"
  acl    = "private"

  lifecycle_rule {
    id      = "${var.name}-glacier-rule"
    prefix  = ""
    enabled = true

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 1825
    }
  }

  versioning {
    enabled = true
  }

  replication_configuration {
    role = aws_iam_role.replication.arn
    rules {
      id = "replicate_data"
      status = "Enabled"
      priority = 1
      destination {
        bucket = aws_s3_bucket.data_lake_bucket_replica.arn
      }
    }
  }
}
