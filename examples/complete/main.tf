provider "alicloud" {
  region = "cn-shanghai"
}

data "alicloud_resource_manager_resource_directories" "default" {}

data "alicloud_resource_manager_accounts" "default" {}

module "cloudsso" {
  source = "../.."
  users = [
    {
      user_name    = "tf-example-user1",
      display_name = "tf-example-user1",
      first_name   = "tf",
      last_name    = "example",
      email        = "tf-example-user1@email.com",
      description  = "This user is used for tf example."
    },
    {
      user_name    = "tf-example-user2",
      display_name = "tf-example-user2",
      first_name   = "tf",
      last_name    = "example",
      email        = "tf-example-user2@email.com",
      description  = "This user is used for tf example."
    }
  ]

  groups = [
    {
      group_name  = "tf-example-group1",
      description = "This group is used for tf example.",
      users       = ["tf-example-user1", "tf-example-user2"]
    },
    {
      group_name  = "tf-example-group2",
      description = "This group is used for tf example.",
      users       = ["tf-example-user1"]
    }
  ]

  access_configurations = [
    {
      access_configuration_name = "Admin",
      description               = "This is a test access configuration for tf example",
      session_duration          = 1000,
      permission_policies = [
        {
          policy_name = "AdministratorAccess",
          policy_type = "System",
        },
        {
          policy_name     = "TestInlineAccess",
          policy_type     = "Inline",
          policy_document = "{\"Statement\":[{\"Action\":\"ecs:Get*\",\"Effect\":\"Allow\",\"Resource\":[\"*\"]}],\"Version\":\"1\"}"
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