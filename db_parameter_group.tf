# --------------------------------------------------------------------------------------------------
# RDS Parameter group
# --------------------------------------------------------------------------------------------------
locals {
  parameter_group_description = "${coalesce(var.parameter_group_description, "Database parameter group for ${var.identifier}")}"
}

resource "aws_db_parameter_group" "this_no_prefix" {
  count = "${var.create_db_parameter_group && ! var.use_parameter_group_name_prefix ? 1 : 0}"

  name        = "${var.parameter_group_name}"
  description = "${local.parameter_group_description}"
  family      = "${var.family}"

  parameter = ["${var.parameters}"]

  tags = "${merge(var.tags, map("Name", format("%s", var.parameter_group_name)))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_parameter_group" "this" {
  count = "${var.create_db_parameter_group && var.use_parameter_group_name_prefix ? 1 : 0}"

  name_prefix = "${var.identifier}-"
  description = "${local.parameter_group_description}"
  family      = "${var.family}"

  parameter = ["${var.parameters}"]

  tags = "${merge(var.tags, map("Name", format("%s", var.identifier)))}"

  lifecycle {
    create_before_destroy = true
  }
}
