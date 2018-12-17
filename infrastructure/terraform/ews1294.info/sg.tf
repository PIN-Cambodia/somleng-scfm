resource "aws_security_group_rule" "freeswitch_main" {
  type        = "ingress"
  from_port   = 5060
  to_port     = 5060
  protocol    = "udp"
  cidr_blocks = ["${aws_eip.freeswitch_eip.public_ip}/32"]
  description = "FreeSWITCH Main"

  security_group_id = "${module.freeswitch_simulator.security_group_id}"
}

resource "aws_security_group" "freeswitch" {
  description = "VPC Security Group"
  vpc_id      = "${module.pin_vpc.vpc_id}"

  tags {
    Name = "FreeSWITCH Security Group"
  }
}

resource "aws_security_group_rule" "smart" {
  type        = "ingress"
  from_port   = 5060
  to_port     = 5060
  protocol    = "udp"
  cidr_blocks = ["27.109.112.0/24"]
  description = "Smart"

  security_group_id = "${aws_security_group.freeswitch.id}"
}

resource "aws_security_group_rule" "metfone" {
  type        = "ingress"
  from_port   = 5060
  to_port     = 5060
  protocol    = "udp"
  cidr_blocks = ["175.100.32.29/32"]
  description = "Metfone"

  security_group_id = "${aws_security_group.freeswitch.id}"
}

resource "aws_security_group_rule" "cellcard" {
  type        = "ingress"
  from_port   = 5060
  to_port     = 5060
  protocol    = "udp"
  cidr_blocks = ["103.193.204.17/32"]
  description = "Cellcard"

  security_group_id = "${aws_security_group.freeswitch.id}"
}

resource "aws_security_group_rule" "freeswitch_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.freeswitch.id}"
}

resource "aws_security_group_rule" "somleng_adhearsion_old" {
  type                     = "ingress"
  from_port                = 5222
  to_port                  = 5222
  protocol                 = "tcp"
  source_security_group_id = "sg-bf3f0adb"
  description              = "Old somleng-adhearsion"

  security_group_id = "${aws_security_group.freeswitch.id}"
}

resource "aws_security_group_rule" "somleng_adhearsion" {
  type                     = "ingress"
  from_port                = 5222
  to_port                  = 5222
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  description              = "Somleng-Adhearsion"

  security_group_id = "${aws_security_group.freeswitch.id}"
}
