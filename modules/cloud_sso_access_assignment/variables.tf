variable "principal" {
  description = "The name of the principal, which can be a user name or a user group name."
  type        = string
  default     = null
}

variable "principal_type" {
  description = "The identity type of the access assignment, which can be a user or a user group. Valid values: Group, User"
  type        = string
  default     = null
}

variable "accounts" {
  description = "The ID of member account to create the resource range"
  type        = list(string)
  default     = null
}

variable "directory_id" {
  description = "The ID of the Cloud SSO Directory"
  type        = string
  default     = null
}

variable "access_configurations" {
  description = "The name list of access configurations to apply on the principal"
  type        = list(string)
  default     = null
}