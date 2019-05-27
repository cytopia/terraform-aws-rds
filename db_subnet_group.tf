# --------------------------------------------------------------------------------------------------
# RDS subnet group
# --------------------------------------------------------------------------------------------------
resource "aws_db_subnet_group" "this_no_prefix" {
  count = "${var.create_db_subnet_group && ! var.use_subnet_group_name_prefix ? 1 : 0}"

  name        = "${var.db_subnet_group_name}"
  description = "${format("Database subnet group for %s", var.identifier)}"
  subnet_ids  = ["${var.subnet_ids}"]

  tags = "${merge(var.tags, map("Name", format("%s", var.db_subnet_group_name)))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "this" {
  count = "${var.create_db_subnet_group && var.use_subnet_group_name_prefix ? 1 : 0}"

  name_prefix = "${var.identifier}-"
  description = "${format("Database subnet group for %s", var.identifier)}"
  subnet_ids  = ["${var.subnet_ids}"]

  tags = "${merge(var.tags, map("Name", format("%s", var.identifier)))}"

  lifecycle {
    create_before_destroy = true
  }
}
