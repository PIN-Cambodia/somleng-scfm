module "eb_solution_stack" {
  source             = "../modules/eb_solution_stacks"
  major_ruby_version = "2.5"
}

module "scfm_eb_app" {
  source = "../modules/eb_app"

  app_identifier   = "${local.scfm_identifier}"
  service_role_arn = "${module.eb_iam.eb_service_role_arn}"
}

module "scfm_eb_app_env" {
  source = "../modules/eb_app_env"

  # General Settings
  app_name            = "${module.scfm_eb_app.app_name}"
  solution_stack_name = "${module.eb_solution_stack.ruby_name}"
  env_identifier      = "${local.scfm_identifier}"

  # VPC
  vpc_id      = "${module.pin_vpc.vpc_id}"
  ec2_subnets = "${module.pin_vpc.private_subnets}"
  elb_subnets = "${module.pin_vpc.public_subnets}"

  # EC2 Settings
  security_groups      = ["${module.scfm_db.security_group}"]
  web_instance_type    = "t2.micro"
  worker_instance_type = "t2.small"
  ec2_instance_role    = "${module.eb_iam.eb_ec2_instance_role}"

  # Elastic Beanstalk Environment
  service_role = "${module.eb_iam.eb_service_role}"

  # Listener
  ssl_certificate_id = "${data.aws_acm_certificate.ews1294.arn}"

  # ENV Vars
  ## Defaults
  aws_region = "${var.aws_region}"

  ## Rails Specific
  rails_env        = "production"
  rails_master_key = "${data.aws_kms_secrets.this.plaintext.scfm_rails_master_key}"
  database_url     = "postgres://${module.scfm_db.db_username}:${module.scfm_db.db_password}@${module.scfm_db.db_instance_endpoint}/${module.scfm_db.db_instance_name}"
  db_pool          = "${local.scfm_db_pool}"

  ## Application Specific
  s3_access_key_id     = "${module.s3_iam.s3_access_key_id}"
  s3_secret_access_key = "${module.s3_iam.s3_secret_access_key}"
  uploads_bucket       = "${aws_s3_bucket.uploads.id}"
  default_url_host     = "${local.scfm_url_host}"
  mailer_sender        = "${local.mailer_sender}@${local.route53_domain_name}"

  ### SCFM Specific
  audio_bucket = "${aws_s3_bucket.audio.id}"
}