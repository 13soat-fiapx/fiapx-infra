variable "environment" {
  type = string
}

variable "datadog_api_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "datadog_site" {
  type    = string
  default = "us5.datadoghq.com"
}
