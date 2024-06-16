module "s3_bucket" {
    source = "./modules/s3"
    bucket = "my-aws-bucket-12323"
}

output "bucket_id" {
    value = module.s3_bucket.s3_bucket_id
}

output "bucket_arn" {
    value = module.s3_bucket.bucket_arn
}    


module "vpc" {
  source = "./modules/vpc"
}

output "vpc_id" {
    value = module.vpc.vpc_id
}