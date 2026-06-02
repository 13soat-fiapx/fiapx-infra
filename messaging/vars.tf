variable "environment" {
  type = string
}

variable "queue_names" {
  type = list(string)
  default = [
    "video-submitted",
    "video-status-changed",
  ]
}
