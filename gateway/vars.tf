variable "environment" {
  type = string
}

variable "services_prefix" {
  type = list(string)
  default = [
    "api",
  ]
}

variable "public_routes" {
  type = list(string)
  default = []
}

variable "auth_issuer" {
  description = "JWT issuer URL"
  default     = "https://dev-oq5eot5o33s27xpo.us.auth0.com"
}

variable "auth_audience" {
  description = "Audience registered for the project"
  default     = "https://fiapx.io"
}
