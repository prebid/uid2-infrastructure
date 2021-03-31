data "aws_availability_zones" "az" {
  filter {
    name   = "region-name"
    values = [ var.region ]
  }
}
