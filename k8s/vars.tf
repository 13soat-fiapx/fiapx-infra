variable "environment" {
  type        = string
  default     = "dev"
}

variable "node_port" {
  type    = number
  default = 30080
}

variable "dd_api_key" {
  type        = string
  sensitive   = true
  default     = ""
  description = "Datadog API Key. If empty, the Datadog Agent will not be installed."
}