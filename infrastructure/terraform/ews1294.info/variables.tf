locals {
  terraform_bucket = "terraform.ews1294.info"
  vpc_name         = "pin-production"
  vpc_azs          = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]

  # For ap-southeast-1. See complete list: http://amzn.to/2E5LUdw
  eb_zone_id                   = "Z16FZ9L249IFLT"
  route53_domain_name          = "ews1294.info"
  internal_route53_domain_name = "internal.ews1294.info"
  mailer_sender                = "no-reply"
}

locals {
  rails_db_pool = "32"
}

locals {
  twilreapi_identifier                  = "somleng-twilreapi"
  twilreapi_route53_record_name         = "somleng"
  twilreapi_deploy_repo                 = "PIN-Cambodia/twilreapi"
  twilreapi_deploy_branch               = "master"
  twilreapi_internal_api_http_auth_user = "admin"
}

locals {
  # remove me when FS is terraformed
  somleng_freeswitch_cname                   = "freeswitch-production.ap-southeast-1.elasticbeanstalk.com"
  somleng_freeswitch_route53_record_name     = "somleng-freeswitch"
  somleng_freeswitch_identifier              = "freeswitch"
  somleng_freeswitch_deploy_repo             = "PIN-Cambodia/freeswitch-config"
  somleng_freeswitch_simulator_deploy_branch = "simulator"
  somleng_freeswitch_xmpp_port               = "5222"
  somleng_freeswitch_mod_rayo_domain_name    = "rayo.peopleinneed.cz"
  somleng_freeswitch_mod_rayo_user           = "adhearsion"
}

locals {
  somleng_adhearsion_route53_record_name = "somleng-adhearsion"
  somleng_adhearsion_identifier          = "somleng-adhearsion"
  somleng_adhearsion_core_username       = "${local.somleng_freeswitch_mod_rayo_user}@${local.somleng_freeswitch_mod_rayo_domain_name}"
  somleng_adhearsion_drb_port            = "9050"
  somleng_adhearsion_deploy_repo         = "PIN-Cambodia/somleng-adhearsion"
  somleng_adhearsion_deploy_branch       = "master"
}

locals {
  scfm_identifier          = "scfm"
  scfm_db_pool             = "32"
  scfm_url_host            = "https://dashboard.ews1294.info"
  scfm_route53_record_name = "dashboard"
  scfm_deploy_repo         = "PIN-Cambodia/somleng-scfm"
  scfm_deploy_branch       = "master"
  scfm_db_master_password  = "AQICAHh5ylDKuj3jGBOphV/NIPGWxWaKQ5XSe4/KMCjtwW8boQHPAvZhwr5RXpsRsCwD0fhNAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMkqG01PH1Gpz7xXU7AgEQgDv304LSC+k2qrNaLThsmtnWqz3P18szS/m6qlg7m7ueh1n/OarmOiO6lCewl2sLPkKFPmkCto6fMp+yyQ=="
  scfm_rails_master_key    = "AQICAHh5ylDKuj3jGBOphV/NIPGWxWaKQ5XSe4/KMCjtwW8boQG5MsAC2Px9SVW8tviwVTssAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMKjKczpG9MigI5A8wAgEQgDudzZ5uuZqIOkG2vnS77/1Gg6FJQK31gIo0yC6R5ucsT4f1m4jNl/5V6hEhep7DTz18eK9Dp6+JilCXdw=="
}

variable "aws_region" {
  default = "ap-southeast-1"
}