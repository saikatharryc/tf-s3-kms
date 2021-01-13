# Create KMS Key
resource "aws_kms_key" "sseproj" {
  count                   = var.create_kms_key ? 1 : 0
  deletion_window_in_days = 15
  tags                    = merge(map("Name", "${var.bucket_name}-key"), var.tags)
  description             = "Key for SSE in S3 for sseproj"
}

# Create the Bucket
resource "aws_s3_bucket" "sseproj" {
  bucket = var.bucket_name
  acl    = "private"
  tags   = var.tags

  # Create Bucket Lifcycle Rules
  # Standard IA has to be atleast from 30 days or more.
  # Glacier Transition should be 30 days or more from the Standard IA in this case, which would be 60
  # Although you can set these numbers from var.
  lifecycle_rule {
    id      = "${var.bucket_name}-lifecycle"
    enabled = true
    tags    = var.tags


    dynamic "transition" {
      for_each = var.enable_standard_ia_transition ? [1] : []

      content {
        days          = var.standard_transition_days
        storage_class = "STANDARD_IA"
      }
    }

    dynamic "transition" {
      for_each = var.enable_glacier_transition ? [1] : []

      content {
        days          = var.glacier_transition_days
        storage_class = "GLACIER"
      }
    }

  }
  # Server side encryption configuration
  # Bucket would always have SSE enabled, just that depending on input it would decide to use default kms key or not.
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.create_kms_key ? aws_kms_key.sseproj[0].arn : "aws/s3"
        sse_algorithm     = "aws:kms"
      }
    }
  }
  depends_on = [aws_kms_key.sseproj]
}

# Get my IP
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# Form the Bucket policy Json
data "aws_iam_policy_document" "default_bucket_policy" {
  statement {
    sid       = "PublicSelfRead"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = [aws_s3_bucket.sseproj.arn, "${aws_s3_bucket.sseproj.arn}/*"]

    principals {
      identifiers = ["*"]
      type        = "*"
    }
    # My current Ip would be able to do GetObject as of now.
    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"

      values = [
        "${trimspace(data.http.myip.body)}/32"
      ]
    }
  }
}

# Replace/Override the policy by the custom one depending on the imput
data "aws_iam_policy_document" "final_bucket_policy" {
  source_json   = var.override_default_bucket_policy ? null : data.aws_iam_policy_document.default_bucket_policy.json
  override_json = var.override_default_bucket_policy ? file("${path.module}/${var.custom_policy}") : null
}

# Set the bucket policy
resource "aws_s3_bucket_policy" "sseproj" {
  bucket     = aws_s3_bucket.sseproj.id
  policy     = data.aws_iam_policy_document.final_bucket_policy.json
  depends_on = [aws_s3_bucket.sseproj]
}