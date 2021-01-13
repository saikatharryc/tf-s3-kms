## Terraform module to create S3 Bucket with multiple options

* You will be able to manage lifecycle of current object versions (Standard IA, Glacier)
* You will be able to create buckets with SSE (Server side encryption enabled enforced for all kind of creation)
* You will be able to provide option to create KMS key for SSE and use if not given it will use the default one `aws/s3`


## Pre-requisite:
* `aws_profile` is required. if not present then have a look at the `example/aws_provider.tf` for other available options(commented out). 
* If you want to override the bucket policy then have the policy in `example/custom_bucket_policy.json` file. (check if the bucket name is correct)


## How to run:

You should have `terraform` cli installed.

Navigate to the `example/` folder for all the required files.
for different options look at `example/*.tfvars`

inside the `example/` dir:

* Create a bucket with KMS key :  `terraform plan --var-file="with-kms.tfvars"`
* Create a bucket without KMS key :  `terraform plan --var-file="without-kms.tfvars"`
* Create a bucket with custom policy for bucket :  `terraform plan --var-file="custom-policy.tfvars"`



NOTE: The state is not being saved in any of the remote location.