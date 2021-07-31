variable "domain" {
  description = "the base domain"
}

variable "public_assets_bucket" {
  description = "The name of the public assets bucket"
}

variable "ssm_parameter_prefix" {
  description = "The prefix to give to all SSM params in this module"
}
