resource "aws_db_subnet_group" "twilreapi" {
  name       = "default-vpc-93669bf7"
  subnet_ids = ["${module.pin_vpc.database_subnets}"]
}

module "scfm_db" {
  source = "../modules/rds"

  env_identifier  = "${local.scfm_identifier}"
  master_password = "${data.aws_kms_secrets.this.plaintext.scfm_db_master_password}"

  vpc_id               = "${module.pin_vpc.vpc_id}"
  db_subnet_group_name = "${module.pin_vpc.database_subnet_group}"

  instance_class    = "db.t2.small"
  identifier        = "scfm-production"
  username          = "scfm"
  engine_version    = "11.1"
  allocated_storage = 5
  storage_encrypted = true
}
