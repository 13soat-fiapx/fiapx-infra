variable "environment" {
  type = string
}

variable "service_names" {
  type = list(string)
  default = [
    "api",
    "processor",
    "notifier"
  ]
}
