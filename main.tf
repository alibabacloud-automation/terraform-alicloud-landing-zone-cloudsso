data "alicloud_cloud_sso_directories" "default" {}

locals {
  directory_id = try(data.alicloud_cloud_sso_directories.default.directories[0].id, "")
}

module "cloud_sso_users_and_groups" {
  source = "./modules/cloud_sso_users_and_groups"
  users  = var.users
  groups = var.groups
}

resource "alicloud_cloud_sso_access_configuration" "default" {
  for_each                  = { for access_configuration in var.access_configurations : access_configuration.access_configuration_name => access_configuration }
  directory_id              = local.directory_id
  access_configuration_name = each.key
  description               = lookup(each.value, "description", null)
  session_duration          = lookup(each.value, "session_duration", null)

  dynamic "permission_policies" {
    for_each = each.value.permission_policies
    content {
      permission_policy_name     = permission_policies.value.policy_name
      permission_policy_type     = permission_policies.value.policy_type
      permission_policy_document = permission_policies.value.policy_type == "Inline" ? permission_policies.value.policy_document : null
    }
  }
}

module "cloud_sso_access_assignment" {
  for_each              = { for access_assignment in var.access_assignments : "${access_assignment.principal_name}-${access_assignment.principal_type}" => access_assignment }
  source                = "./modules/cloud_sso_access_assignment"
  principal             = each.value.principal_name
  principal_type        = each.value.principal_type
  directory_id          = local.directory_id
  access_configurations = each.value.access_configurations
  accounts              = each.value.accounts

  depends_on = [
    alicloud_cloud_sso_access_configuration.default,
    module.cloud_sso_users_and_groups
  ]
}