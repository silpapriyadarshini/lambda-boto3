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

data "aws_iam_policy_document" "lambda_for_rekognition" {
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

resource "aws_iam_policy" "lambda_for_rekognition_policy" {
  name = "lambda-for-rekognition"
  description = "Allow Lambda function to use rekognition"
  policy = data.aws_iam_policy_document.lambda_for_rekognition.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_for_rekognition_policy.arn
}