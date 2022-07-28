import boto3
import json


#FOR S3 BUCKET
#create boto3 client
s3_client = boto3.client('s3')
response = s3_client.list_buckets()
#print(json.dumps(response,default=str))

#To get bucket name
#for data in response["Buckets"]:
#    print(data["Name"])


s3 = boto3.resource('s3')
bucket_versioning = s3.BucketVersioning('bucket_name')
#print(bucket_versioning)
