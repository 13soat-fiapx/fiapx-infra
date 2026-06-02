resource "aws_ecr_repository" "container_registry" {
  for_each = toset(var.service_names)

  name = "${local.prefix}/${each.value}-cr"

  image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"

  image_tag_mutability_exclusion_filter {
    filter      = "latest"
    filter_type = "WILDCARD"
  }

  force_delete = true
}
