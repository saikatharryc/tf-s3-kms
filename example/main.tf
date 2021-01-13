module "s3" {
  source = "git::https://github.com/saikatharryc/tf-s3-kms.git?ref=master"

  aws_region  = var.aws_region
  bucket_name = var.bucket_name
  tags        = var.tags

  create_kms_key = var.create_kms_key

  enable_standard_ia_transition = var.enable_standard_ia_transition
  standard_transition_days      = var.standard_transition_days
  enable_glacier_transition     = var.enable_glacier_transition
  glacier_transition_days       = var.glacier_transition_days

  override_default_bucket_policy = var.override_default_bucket_policy
  custom_policy                  = var.custom_policy
}