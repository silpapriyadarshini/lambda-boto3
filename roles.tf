resource "aws_iam_role" "lab_lambda_role" {
  name = "lab-lambda-role"

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
    tag-key = "lab-lambda-role"
  }
}

data "aws_iam_policy_document" "lambda_for_rekognition" {
  statement {
    sid = "LambdaForRekognition"
    actions = [
      "rekognition:*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_for_s3_access" {
  statement {
    sid = "LambdaAccessS3Bucket"
    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.lab_image_lambda_bucket.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.lab_image_lambda_bucket.bucket}/*"
    ]
  }
}

data "aws_iam_policy_document" "lambda_for_dynamodb" {
  statement {
    sid = "LambdaAccessdynamoDB"
    actions = [
      "dynamodb:PutItem"
    ]
    resources = [
      aws_dynamodb_table.lambda_image_rekognition.arn
    ]
  }
}

resource "aws_iam_policy" "lambda_for_rekognition_policy" {
  name = "lambda-for-rekognition"
  description = "Allow Lambda function to use rekognition"
  policy = data.aws_iam_policy_document.lambda_for_rekognition.json
}

resource "aws_iam_policy" "lambda_for_s3_access_policy" {
  name = "lambda-for-s3-access"
  description = "Allow Lambda function to access S3 bucket and objects"
  policy = data.aws_iam_policy_document.lambda_for_s3_access.json
}

resource "aws_iam_policy" "lambda_for_dynamodb_policy" {
  name = "lambda-for-dynamodb"
  description = "Allow Lambda function to write item into dynamoDB"
  policy = data.aws_iam_policy_document.lambda_for_dynamodb.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role = aws_iam_role.lab_lambda_role.name
  policy_arn = aws_iam_policy.lambda_for_rekognition_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_access_s3" {
  role = aws_iam_role.lab_lambda_role.name
  policy_arn = aws_iam_policy.lambda_for_s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_write_dynamodb" {
  role = aws_iam_role.lab_lambda_role.name
  policy_arn = aws_iam_policy.lambda_for_dynamodb_policy.arn
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_image_rekog.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.lab_image_lambda_bucket.arn
}