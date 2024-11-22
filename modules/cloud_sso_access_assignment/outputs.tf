output "access_assignment_ids" {
  description = "the resource ID list of Access Assignment. The ID formats as <directory_id>:<access_configuration_id>:<target_type>:<target_id>:<principal_type>:<principal_id>"
  value = [
    for assignment in alicloud_cloud_sso_access_assignment.default : assignment.id
  ]
}