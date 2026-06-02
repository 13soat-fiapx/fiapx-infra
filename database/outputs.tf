output "environment" {
  value = var.environment
}

output "tables" {
  value = {
    videos = module.videos_table.table_name
  }
}
