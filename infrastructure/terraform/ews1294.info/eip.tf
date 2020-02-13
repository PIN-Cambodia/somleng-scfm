resource "aws_eip" "freeswitch_eip" {
  vpc = true

  tags {
    Name = "FreeSWITCH Public IP"
  }
}
