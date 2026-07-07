module "videos_table" {
  source = "./table_module"

  environment = var.environment
  table_name  = "videos"

  global_secondary_indexes = [
    {
      name = "userId-index"
      key_schema = [
        { attribute_name = "userId", key_type = "HASH" },
      ]
    },
    {
      name = "resultFileId-index"
      key_schema = [
        { attribute_name = "resultFileId", key_type = "HASH" },
      ]
    }
  ]
}
