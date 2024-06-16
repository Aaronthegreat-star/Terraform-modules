output "s3_bucket_id" {
    value = aws_s3_bucket.nitro.id 
}
output "bucket_arn" {
    value = aws_s3_bucket.nitro.arn 
}