variable "users" {
  description = "A list of cloud sso users. The user_name must be unique in cloud sso."
  type = list(object({
    user_name    = string
    display_name = optional(string)
    first_name   = optional(string)
    last_name    = optional(string)
    email        = optional(string)
    description  = optional(string)
  }))
  default = []
}

variable "groups" {
  description = "A list of cloud sso groups. The group_name must be unique in cloud sso and the users is a list of user name."
  type = list(object({
    group_name  = string
    description = optional(string)
    users       = optional(list(string), [])
  }))
  default = []
}

variable "access_configurations" {
  description = "A list of cloud sso access configurations in which each element contains the following attributes. The access_configuration_name must be unique in cloud sso. The value of session_duration(Unit: Seconds) should between 900 to 43200. The permission policies is a list of Policy which will be assigned to the access configuration. The permission_policy_type can be either System or Inline. If permission_policy_type is set to Inline, permission_policy_document is required."
  type = list(object({
    access_configuration_name = string
    description               = optional(string)
    session_duration          = optional(number)
    permission_policies = optional(list(object({
      policy_name     = string
      policy_type     = string
      policy_document = optional(string)
    })), [])
  }))
  default = []
}

variable "access_assignments" {
  description = "A list of access assignments in which each element contains the following attributes: The principal_namecan be either a user name or a group name, depending on the principal_type (valid values: User, Group). The access_configurations should be a list of access configurations names. The accounts should be a list of account IDs which could contain the master account or member accounts in Resource Directory."
  type = list(object({
    principal_name        = string
    principal_type        = string
    access_configurations = list(string)
    accounts              = list(string)
  }))
  default = []
}