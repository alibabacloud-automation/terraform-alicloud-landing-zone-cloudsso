output "user_ids" {
  description = "The User ID list of the users."
  value = [
    for user in alicloud_cloud_sso_user.default : user.user_id
  ]
}

output "group_ids" {
  description = "The Group ID list of the group"
  value = [
    for group in alicloud_cloud_sso_group.default : group.group_id
  ]
}

output "user_attachment_ids" {
  description = "The resource ID of User Attachment. The value formats as <directory_id>:<group_id>:<user_id>"
  value = [
    for attachment in alicloud_cloud_sso_user_attachment.default : attachment.id
  ]
}