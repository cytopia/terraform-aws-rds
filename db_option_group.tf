# --------------------------------------------------------------------------------------------------
# RDS Option Group
# --------------------------------------------------------------------------------------------------
locals {
  option_group_description = "${coalesce(var.option_group_description, "Option group for ${var.identifier}")}"
}

resource "aws_db_option_group" "this_no_prefix" {
  count = "${var.create_db_option_group && ! var.use_option_group_name_prefix ? 1 : 0}"

  name                     = "${var.option_group_name}"
  option_group_description = "${local.option_group_description}"
  engine_name              = "${var.engine}"
  major_engine_version     = "${var.major_engine_version}"

  option = ["${var.options}"]

  tags = "${merge(var.tags, map("Name", format("%s", var.option_group_name)))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_option_group" "this" {
  count = "${var.create_db_option_group && var.use_option_group_name_prefix ? 1 : 0}"

  name_prefix              = "${var.identifier}-"
  option_group_description = "${local.option_group_description}"
  engine_name              = "${var.engine}"
  major_engine_version     = "${var.major_engine_version}"

  option = ["${var.options}"]

  tags = "${merge(var.tags, map("Name", format("%s", var.identifier)))}"

  lifecycle {
    create_before_destroy = true
  }
}
