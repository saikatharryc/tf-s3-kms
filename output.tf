output "bucket_name" {
  value = aws_s3_bucket.sseproj.id
}

output "bucket_arn" {
  value = aws_s3_bucket.sseproj.arn
}

output "key_arn" {
  value = var.create_kms_key ? aws_kms_key.sseproj[0].arn : "aws/s3"
}