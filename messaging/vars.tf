variable "environment" {
  type = string
}

variable "queue_names" {
  type = list(string)
  default = [
    "video-processing-requested",
    "video-processing-completed",
  ]
}
