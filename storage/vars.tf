variable "environment" {
  type = string
}

variable "cors_allowed_origins" {
  type = list(string)
  default = [
    "http://localhost:8080",
    "https://d2nyagk7gn75jo.cloudfront.net"
  ]
}
