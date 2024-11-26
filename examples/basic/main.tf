provider "alicloud" {
  region = "cn-shanghai"
}

data "alicloud_resource_manager_resource_directories" "default" {}

data "alicloud_resource_manager_accounts" "default" {}

module "cloudsso" {
  source = "../.."
  users = [
    {
      user_name = "tf-example-user1"
    }
  ]

  groups = [
    {
      group_name = "tf-example-group1"
    }
  ]

  access_configurations = [
    {
      access_configuration_name = "Admin",
      permission_policies = [
        {
          policy_name = "AdministratorAccess",
          policy_type = "System",
        }
      ]
    }
  ]

  access_assignments = [
    {
      principal_name        = "tf-example-user1",
      principal_type        = "User",
      access_configurations = ["Admin"],
      accounts              = [data.alicloud_resource_manager_resource_directories.default.directories[0].master_account_id]
    },
    {
      principal_name        = "tf-example-group1",
      principal_type        = "Group",
      access_configurations = ["Admin"],
      accounts              = [data.alicloud_resource_manager_accounts.default.accounts[0].account_id]
    }
  ]
}