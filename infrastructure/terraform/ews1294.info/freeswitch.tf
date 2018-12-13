module "somleng_freeswitch_eb_app" {
  source = "../modules/eb_app"

  app_identifier   = "${local.somleng_freeswitch_identifier}"
  service_role_arn = "${module.eb_iam.eb_service_role_arn}"
}

module "freeswitch_simulator" {
  source = "../modules/freeswitch"

  app_name       = "${module.somleng_freeswitch_eb_app.app_name}"
  env_identifier = "${local.somleng_freeswitch_identifier}-simulator"

  vpc_id                          = "${module.pin_vpc.vpc_id}"
  elb_subnets                     = "${module.pin_vpc.intra_subnets}"
  ec2_subnets                     = "${module.pin_vpc.public_subnets}"
  ec2_instance_role               = "${module.eb_iam.eb_ec2_instance_role}"
  eb_service_role                 = "${module.eb_iam.eb_service_role}"
  aws_region                      = "${var.aws_region}"
  xmpp_listener_enabled           = "false"
  associate_eip_event_detail_type = "${module.associate_eip.event_detail_type}"
  associate_eip_lambda_arn        = "${module.associate_eip.lambda_arn}"
  eip_allocation_id_tag_key       = "${module.associate_eip.eip_allocation_id_tag_key}"

  deploy_repo   = "${local.somleng_freeswitch_deploy_repo}"
  deploy_branch = "${local.somleng_freeswitch_simulator_deploy_branch}"
  travis_token  = "${var.travis_token}"
  simulator     = "true"
}
