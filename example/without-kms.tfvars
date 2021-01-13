aws_profile                    = "default-terraform"
aws_region                     = "eu-west-1"
bucket_name                    = "testbucket-dsfghjkl"
enable_standard_ia_transition  = true
standard_transition_days       = 30
enable_glacier_transition      = true
glacier_transition_days        = 60
override_default_bucket_policy = false
custom_policy                  = "example/custom_bucket_policy.json"