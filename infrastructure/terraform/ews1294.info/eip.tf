module "associate_eip" {
  source = "../modules/associate_eip"
}

resource "aws_eip" "freeswitch_eip" {
  vpc = true

  tags {
    Name = "FreeSWITCH Public IP"
  }
}

# resource "aws_eip_association" "eip" {
#   instance_id   = "${element(module.eb_env.instances, 0)}"
#   allocation_id = "${aws_eip.eip.id}"
# }

