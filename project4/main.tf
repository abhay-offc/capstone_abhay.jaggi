resource "aws_iam_user" "user" {
  name = "s3-user-yoshi"
}

resource "aws_iam_policy" "s3_read" {
  name   = "custom-s3-read-policy"
  policy = jsonencode(var.s3_read_policy)
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.s3_read.arn
}

resource "aws_iam_user_login_profile" "user" {
  user                    = aws_iam_user.user.name
  password_reset_required = false
}
