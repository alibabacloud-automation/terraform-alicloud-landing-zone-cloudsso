output "user_ids" {
  description = "The id of users."
  value       = module.cloud_sso_users_and_groups.user_ids
}

output "group_ids" {
  description = "The id of groups"
  value       = module.cloud_sso_users_and_groups.group_ids
}

output "user_attachment_ids" {
  description = "The id of user attachments. The value formats as <directory_id>:<group_id>:<user_id>"
  value       = module.cloud_sso_users_and_groups.user_attachment_ids
}

output "access_configuration_ids" {
  description = "The access configuration id list of access configurations."
  value = [
    for configuration in alicloud_cloud_sso_access_configuration.default : configuration.access_configuration_id
  ]
}

output "access_assignments_ids" {
  description = "the id of access assignments. The value formats as <directory_id>:<access_configuration_id>:<target_type>:<target_id>:<principal_type>:<principal_id>"
  value = flatten([
    for cloud_sso_access_assignment in module.cloud_sso_access_assignment : cloud_sso_access_assignment.access_assignment_ids
  ])
}