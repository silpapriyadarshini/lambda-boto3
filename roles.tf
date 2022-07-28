resource "aws_iam_role" "lambda_role" {
  name = "lab-lambda-assume-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "lab-lambda-assume-role"
  }
}

data "aws_iam_policy_document" "lab_lambda_for_rekognition" {
  statement {
    sid = "LambdaForRekognition"
    actions = [
      "rekognition:*",
      #"logs:CreateLogGroup",
      #"logs:CreateLogStream",
      #"logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

