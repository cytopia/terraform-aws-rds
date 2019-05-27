# --------------------------------------------------------------------------------------------------
# Enhanced Monitoring
# --------------------------------------------------------------------------------------------------
resource "aws_iam_role" "enhanced_monitoring" {
  count = "${var.create_monitoring_role ? 1 : 0}"

  name               = "${var.monitoring_role_name}"
  assume_role_policy = "${file("${path.module}/data/policy/enhancedmonitoring.json")}"
  tags               = "${merge(map("Name", format("%s", var.monitoring_role_name)), var.tags)}"
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count = "${var.create_monitoring_role ? 1 : 0}"

  role       = "${aws_iam_role.enhanced_monitoring.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
