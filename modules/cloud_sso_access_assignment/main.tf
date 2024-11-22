data "alicloud_cloud_sso_users" "default" {
  count        = var.principal_type == "User" ? 1 : 0
  directory_id = var.directory_id
  name_regex   = var.principal
}

data "alicloud_cloud_sso_groups" "default" {
  count        = var.principal_type == "Group" ? 1 : 0
  directory_id = var.directory_id
  name_regex   = var.principal
}

data "alicloud_cloud_sso_access_configurations" "default" {
  for_each     = toset(var.access_configurations)
  directory_id = var.directory_id
  name_regex   = each.value
}

locals {
  principal_id = var.principal_type == "User" ? data.alicloud_cloud_sso_users.default[0].users[0].user_id : data.alicloud_cloud_sso_groups.default[0].groups[0].group_id

  account_with_access_configuration_set = flatten([
    for account in var.accounts : [
      for access_configuration in var.access_configurations : {
        account              = account
        access_configuration = access_configuration
      }
    ]
  ])
}

resource "alicloud_cloud_sso_access_assignment" "default" {
  for_each                = { for account_with_access_configuration in local.account_with_access_configuration_set : "${account_with_access_configuration.account}-${account_with_access_configuration.access_configuration}" => account_with_access_configuration }
  directory_id            = var.directory_id
  principal_id            = local.principal_id
  principal_type          = var.principal_type
  target_id               = each.value.account
  access_configuration_id = data.alicloud_cloud_sso_access_configurations.default[each.value.access_configuration].configurations[0].access_configuration_id
  target_type             = "RD-Account"
}