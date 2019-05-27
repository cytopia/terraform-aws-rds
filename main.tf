# --------------------------------------------------------------------------------------------------
# RDS locals
# --------------------------------------------------------------------------------------------------
locals {
  is_mssql = "${element(split("-",var.engine), 0) == "sqlserver"}"
}

locals {
  db_subnet_group_name    = "${element(concat(coalescelist(aws_db_subnet_group.this.*.id, aws_db_subnet_group.this_no_prefix.*.id), list("")), 0)}"
  db_parameter_group_name = "${element(concat(coalescelist(aws_db_parameter_group.this.*.id, aws_db_parameter_group.this_no_prefix.*.id), list("")), 0)}"
  db_option_group_name    = "${element(concat(coalescelist(aws_db_option_group.this.*.id, aws_db_option_group.this_no_prefix.*.id), list("")), 0)}"
}

# --------------------------------------------------------------------------------------------------
# RDS instance (generic)
# --------------------------------------------------------------------------------------------------
resource "aws_db_instance" "this" {
  count = "${var.create_db_instance && !local.is_mssql ? 1 : 0}"

  # Database (server) defines
  identifier        = "${var.identifier}"
  engine            = "${var.engine}"
  engine_version    = "${var.engine_version}"
  instance_class    = "${var.instance_class}"
  allocated_storage = "${var.allocated_storage}"
  storage_type      = "${var.storage_type}"
  storage_encrypted = "${var.storage_encrypted}"
  kms_key_id        = "${var.kms_key_id}"
  license_model     = "${var.license_model}"

  # Database (Schema) defines
  name                                = "${var.name}"
  username                            = "${var.username}"
  password                            = "${var.password}"
  port                                = "${var.port}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"

  replicate_source_db = "${var.replicate_source_db}"

  snapshot_identifier = "${var.snapshot_identifier}"

  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]

  # Resources available in respective tf files
  db_subnet_group_name = "${local.db_subnet_group_name}"
  parameter_group_name = "${local.db_parameter_group_name}"
  option_group_name    = "${local.db_option_group_name}"

  availability_zone   = "${var.availability_zone}"
  multi_az            = "${var.multi_az}"
  iops                = "${var.iops}"
  publicly_accessible = "${var.publicly_accessible}"
  monitoring_interval = "${var.monitoring_interval}"
  monitoring_role_arn = "${coalesce(var.monitoring_role_arn, join("", aws_iam_role.enhanced_monitoring.*.arn))}"

  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  apply_immediately           = "${var.apply_immediately}"
  maintenance_window          = "${var.maintenance_window}"
  skip_final_snapshot         = "${var.skip_final_snapshot}"
  copy_tags_to_snapshot       = "${var.copy_tags_to_snapshot}"
  final_snapshot_identifier   = "${var.final_snapshot_identifier}"

  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"

  character_set_name = "${var.character_set_name}"

  enabled_cloudwatch_logs_exports = "${var.enabled_cloudwatch_logs_exports}"

  timeouts = "${var.timeouts}"

  deletion_protection = "${var.deletion_protection}"

  tags = "${merge(var.tags, map("Name", format("%s", var.identifier)))}"
}

# --------------------------------------------------------------------------------------------------
# RDS instance (MSSQL)
# --------------------------------------------------------------------------------------------------
resource "aws_db_instance" "this_mssql" {
  count = "${var.create_db_instance && local.is_mssql ? 1 : 0}"

  identifier = "${var.identifier}"

  # Database (server) defines
  engine            = "${var.engine}"
  engine_version    = "${var.engine_version}"
  instance_class    = "${var.instance_class}"
  allocated_storage = "${var.allocated_storage}"
  storage_type      = "${var.storage_type}"
  storage_encrypted = "${var.storage_encrypted}"
  kms_key_id        = "${var.kms_key_id}"
  license_model     = "${var.license_model}"

  # Database (Schema) defines
  name                                = "${var.name}"
  username                            = "${var.username}"
  password                            = "${var.password}"
  port                                = "${var.port}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"

  replicate_source_db = "${var.replicate_source_db}"

  snapshot_identifier = "${var.snapshot_identifier}"

  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]

  # Resources available in respective tf files
  db_subnet_group_name = "${local.db_subnet_group_name}"
  parameter_group_name = "${local.db_parameter_group_name}"
  option_group_name    = "${local.db_option_group_name}"

  availability_zone   = "${var.availability_zone}"
  multi_az            = "${var.multi_az}"
  iops                = "${var.iops}"
  publicly_accessible = "${var.publicly_accessible}"
  monitoring_interval = "${var.monitoring_interval}"
  monitoring_role_arn = "${coalesce(var.monitoring_role_arn, join("", aws_iam_role.enhanced_monitoring.*.arn))}"

  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  apply_immediately           = "${var.apply_immediately}"
  maintenance_window          = "${var.maintenance_window}"
  skip_final_snapshot         = "${var.skip_final_snapshot}"
  copy_tags_to_snapshot       = "${var.copy_tags_to_snapshot}"
  final_snapshot_identifier   = "${var.final_snapshot_identifier}"

  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"

  timezone = "${var.timezone}"

  enabled_cloudwatch_logs_exports = "${var.enabled_cloudwatch_logs_exports}"

  timeouts = "${var.timeouts}"

  deletion_protection = "${var.deletion_protection}"

  tags = "${merge(var.tags, map("Name", format("%s", var.identifier)))}"
}
