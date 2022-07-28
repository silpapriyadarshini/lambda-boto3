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


bucket_version = s3_client.get_bucket_versioning(
                Bucket='talent-academy-silpa-lab-tfstates'
                )

print(json.dumps(bucket_version,default='str'))
