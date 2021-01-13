variable "aws_region" {
  type = string
}
variable "aws_profile" {
  type = string
}
variable "bucket_name" {
  type = string
}
variable "create_kms_key" {
  type    = bool
  default = false
}
variable "tags" {
  default = {
    "createdBy" = "saikatharryc"
  }
}


variable "enable_glacier_transition" {
  type    = bool
  default = false
}
variable "enable_standard_ia_transition" {
  type    = bool
  default = false
}

variable "standard_transition_days" {
  type        = number
  default     = 30
  description = "Number of days after which to move the data to the Infrequent Access storage tier"
}
variable "glacier_transition_days" {
  type        = number
  default     = 60
  description = "Number of days after which to move the data to the glacier storage tier"
}
variable "override_default_bucket_policy" {
  type    = bool
  default = false
}


variable "custom_policy" {
  type        = string
  description = "Custom Policy file if incase not going with default one set."
}