resource "aws_route53_zone" "ews1294_info" {
  name = "${local.route53_domain_name}."
}

resource "aws_route53_zone" "internal" {
  name   = "${local.internal_route53_domain_name}."
  vpc_id = "${module.pin_vpc.vpc_id}"
}

module "route53_record_somleng_freeswitch" {
  source = "../modules/route53_alias_record"

  hosted_zone_id       = "${aws_route53_zone.internal.zone_id}"
  record_name          = "${local.somleng_freeswitch_route53_record_name}"
  alias_dns_name       = "${local.somleng_freeswitch_cname}"
  alias_hosted_zone_id = "${local.eb_zone_id}"
}

module "route53_record_somleng_adhearsion" {
  source = "../modules/route53_alias_record"

  hosted_zone_id       = "${aws_route53_zone.internal.zone_id}"
  record_name          = "${local.somleng_adhearsion_route53_record_name}"
  alias_dns_name       = "${module.somleng_adhearsion_webserver.cname}"
  alias_hosted_zone_id = "${local.eb_zone_id}"
}

module "route53_record_somleng_twilreapi" {
  source = "../modules/route53_alias_record"

  hosted_zone_id       = "${aws_route53_zone.ews1294_info.zone_id}"
  record_name          = "${local.twilreapi_route53_record_name}"
  alias_dns_name       = "${module.twilreapi_eb_app_env.web_cname}"
  alias_hosted_zone_id = "${local.eb_zone_id}"
}

module "route53_record_scfm" {
  source = "../modules/route53_alias_record"

  hosted_zone_id       = "${aws_route53_zone.ews1294_info.zone_id}"
  record_name          = "${local.scfm_route53_record_name}"
  alias_dns_name       = "${module.scfm_eb_app_env.web_cname}"
  alias_hosted_zone_id = "${local.eb_zone_id}"
}
