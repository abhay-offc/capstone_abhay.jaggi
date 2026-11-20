output "user_id" {
  value = aws_iam_user.user.id
}

output "user_name" {
  value = aws_iam_user.user.name
}

output "console_password" {
  value     = aws_iam_user_login_profile.user.password
  sensitive = true
}
