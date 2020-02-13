output "aws_kms_key_master" {
  value = "${aws_kms_key.master.id}"
}

output "ci-deploy-bucket" {
  value = "${aws_s3_bucket.ci_deploy.id}"
}
