terraform {
    backend "s3" {
        bucket = "talent-academy-silpa-lab-tfstates"
        key = "talent-academy/lambda/terraform.tfstates"
        region = "eu-west-1"
        dynamodb_table = "terraform-lock"
    }
}