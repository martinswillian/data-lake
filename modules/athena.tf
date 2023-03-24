# Athena workgroup
resource "aws_athena_workgroup" "data_lake_workgroup" {
  name = "${var.name}-workgroup"
}
