Terraform module to implements Multi-Account Single Sign-On by Cloud SSO.

# terraform-alicloud-landing-zone-cloudsso

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-landing-zone-cloudsso/blob/main/README-CN.md)

When enterprises adopt a multi-account cloud architecture, configuring personnel identities and permission policies for each account becomes very cumbersome and time-consuming. This module leverages the product capabilities of cloud SSO to provide a centralized way to manage identities and permissions across multiple accounts, simplifying the complexity of identity configuration for enterprise IT administrators.

![Structure](https://raw.githubusercontent.com/alibabacloud-automation/terraform-alicloud-landing-zone-cloudsso/main/pictures/structure.png)

## Prerequisites

Enable Alicloud CloudSSO

## Usage

Manage Alicloud CloudSSO users, groups, access configurations and access assignments with Terraform. If you have already created users and groups through SCIM synchronization or other methods, the users and groups parameters could be set to empty list or ignored.

```terraform
provider "alicloud" {
  region = "cn-shanghai"
}

data "alicloud_resource_manager_resource_directories" "default" {}

data "alicloud_resource_manager_accounts" "default" {}

module "cloudsso" {
  source = "alibabacloud-automation/landing-zone-cloudsso/alicloud"
  users = [
    {
      user_name = "tf-example-user1",
      display_name = "tf-example-user1",
      first_name = "tf",
      last_name = "example",
      email = "tf-example-user1@email.com",
      description = "This user is used for tf example."
    },
    {    
      user_name = "tf-example-user2",
      display_name = "tf-example-user2",
      first_name = "tf",
      last_name = "example",
      email = "tf-example-user2@email.com",
      description = "This user is used for tf example."
    }
  ]

  groups = [
    {
      group_name = "tf-example-group1",
      description = "This group is used for tf example.",
      users = ["tf-example-user1", "tf-example-user2"]
    },
    {
      group_name = "tf-example-group2",
      description = "This group is used for tf example.",
      users = ["tf-example-user1"]
    }
  ]
  
  access_configurations = [
    {
      access_configuration_name = "Admin",
      description = "This is a test access configuration for tf example",
      session_duration = 1000,
      permission_policies = [
        {
            policy_name = "AdministratorAccess",
            policy_type = "System",
        },
        {
            policy_name = "TestInlineAccess",
            policy_type = "Inline",
            policy_document = "{\"Statement\":[{\"Action\":\"ecs:Get*\",\"Effect\":\"Allow\",\"Resource\":[\"*\"]}],\"Version\":\"1\"}"
        }
      ]
    }
  ]

  access_assignments = [
    {
      principal_name = "tf-example-user1",
      principal_type = "User",
      access_configurations = ["Admin"],
      accounts = [data.alicloud_resource_manager_resource_directories.default.directories[0].master_account_id]
    },
    {
      principal_name = "tf-example-group1",
      principal_type = "Group",
      access_configurations = ["Admin"],
      accounts = [data.alicloud_resource_manager_accounts.default.accounts[0].account_id]
    }
  ]
}
```

## Examples

- [Basic Example](https://github.com/alibabacloud-automation/terraform-alicloud-landing-zone-cloudsso/tree/main/examples/basic)
- [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-landing-zone-cloudsso/tree/main/examples/complete)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.10 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) |  >= 1.145.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) |  >= 1.145.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_sso_access_assignment"></a> [cloud\_sso\_access\_assignment](#module\_cloud\_sso\_access\_assignment) | ./modules/cloud_sso_access_assignment | n/a |
| <a name="module_cloud_sso_users_and_groups"></a> [cloud\_sso\_users\_and\_groups](#module\_cloud\_sso\_users\_and\_groups) | ./modules/cloud_sso_users_and_groups | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_cloud_sso_access_configuration.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cloud_sso_access_configuration) | resource |
| [alicloud_cloud_sso_directories.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/cloud_sso_directories) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_assignments"></a> [access\_assignments](#input\_access\_assignments) | A list of access assignments in which each element contains the following attributes: The principal\_namecan be either a user name or a group name, depending on the principal\_type (valid values: User, Group). The access\_configurations should be a list of access configurations names. The accounts should be a list of account IDs which could contain the master account or member accounts in Resource Directory. | <pre>list(object({<br/>    principal_name        = string<br/>    principal_type        = string<br/>    access_configurations = list(string)<br/>    accounts              = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_access_configurations"></a> [access\_configurations](#input\_access\_configurations) | A list of cloud sso access configurations in which each element contains the following attributes. The access\_configuration\_name must be unique in cloud sso. The value of session\_duration(Unit: Seconds) should between 900 to 43200. The permission policies is a list of Policy which will be assigned to the access configuration. The permission\_policy\_type can be either System or Inline. If permission\_policy\_type is set to Inline, permission\_policy\_document is required. | <pre>list(object({<br/>    access_configuration_name = string<br/>    description               = optional(string)<br/>    session_duration          = optional(number)<br/>    permission_policies = optional(list(object({<br/>      policy_name     = string<br/>      policy_type     = string<br/>      policy_document = optional(string)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_groups"></a> [groups](#input\_groups) | A list of cloud sso groups. The group\_name must be unique in cloud sso and the users is a list of user name. | <pre>list(object({<br/>    group_name  = string<br/>    description = optional(string)<br/>    users       = optional(list(string), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_users"></a> [users](#input\_users) | A list of cloud sso users. The user\_name must be unique in cloud sso. | <pre>list(object({<br/>    user_name    = string<br/>    display_name = optional(string)<br/>    first_name   = optional(string)<br/>    last_name    = optional(string)<br/>    email        = optional(string)<br/>    description  = optional(string)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_assignments_ids"></a> [access\_assignments\_ids](#output\_access\_assignments\_ids) | the id of access assignments. The value formats as <directory\_id>:<access\_configuration\_id>:<target\_type>:<target\_id>:<principal\_type>:<principal\_id> |
| <a name="output_access_configuration_ids"></a> [access\_configuration\_ids](#output\_access\_configuration\_ids) | The access configuration id list of access configurations. |
| <a name="output_group_ids"></a> [group\_ids](#output\_group\_ids) | The id of groups |
| <a name="output_user_attachment_ids"></a> [user\_attachment\_ids](#output\_user\_attachment\_ids) | The id of user attachments. The value formats as <directory\_id>:<group\_id>:<user\_id> |
| <a name="output_user_ids"></a> [user\_ids](#output\_user\_ids) | The id of users. |

## Submit Issues

If you have any problems when using this module, please opening a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

- [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
- [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
- [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)