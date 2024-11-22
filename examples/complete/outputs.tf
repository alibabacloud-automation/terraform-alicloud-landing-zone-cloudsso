output "user_ids" {
  description = "The id of users."
  value       = module.cloudsso.user_ids
}

output "group_ids" {
  description = "The id of groups"
  value       = module.cloudsso.group_ids
}

output "user_attachment_ids" {
  description = "The id of user attachments. The value formats as <directory_id>:<group_id>:<user_id>"
  value       = module.cloudsso.user_attachment_ids
}

output "access_configuration_ids" {
  description = "The AccessConfigurationId list of the Access Configurations."
  value       = module.cloudsso.access_configuration_ids
}

output "access_assignments_ids" {
  description = "the resource ID list of Access Assignments. The ID formats as <directory_id>:<access_configuration_id>:<target_type>:<target_id>:<principal_type>:<principal_id>"
  value       = module.cloudsso.access_assignments_ids
}