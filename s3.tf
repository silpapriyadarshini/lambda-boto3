resource "aws_s3_bucket" "lab_image_lambda_bucket" {
    bucket = "ta-lab-lambda-bucket"
    
    tags = {
        Name = "ta-lab-lambda-bucket"
        Environment = "Lab"
    }
}

resource "aws_s3_bucket_notification" "s3_bucket_notification" {
   bucket = aws_s3_bucket.lab_image_lambda_bucket.id

   lambda_function {
     lambda_function_arn = aws_lambda_function.lambda_image_rekog.arn
     events              = ["s3:ObjectCreated:*"]
   }
}