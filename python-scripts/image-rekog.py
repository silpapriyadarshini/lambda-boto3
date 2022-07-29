import boto3
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)
metadata_table = os.environ["METADATA_TABLE"]


def lambda_handler(event, context):
    client = boto3.client("rekognition")
    dynamodb_resource = boto3.resource("dynamodb")

    for record in event["Records"]:
        bucket_name = record["s3"]["bucket"]["name"]
        image_obj = record["s3"]["object"]["key"]

    number_of_faces = 0
    male_face = 0
    female_face = 0
    eye_glasses=0
    sun_glasses=0
    Mustache_face=0
    
    #print(number_of_faces)

    response = client.detect_faces(Image={'S3Object':{'Bucket':bucket_name,'Name':image_obj}},Attributes=['ALL'])
    
    faces = response["FaceDetails"]

    number_of_faces = len(faces)
    print(number_of_faces)

    for face in faces:
        if face["Gender"]["Value"] == "Male":
            male_face += 1
        elif face["Gender"]["Value"] == "Female":
            female_face += 1

    for face in faces:   
        if face["Eyeglasses"]["Value"] != False:
            eye_glasses +=1

    for face in faces: 
        if face["Mustache"]["Value"] != False:
            Mustache_face +=1

    for face in faces:
        if face["Sunglasses"]["Value"] != False:
            sun_glasses +=1
    
    
        #print("the landmark is", str(face[Landmarks][Type]))

    print(male_face)
    print(female_face)
    print(eye_glasses)
    print(Mustache_face)
    print(sun_glasses)

    table = dynamodb_resource.Table(metadata_table)

    metadata = {
        "filename": image_obj,
        "number_of_faces": number_of_faces,
        "male_faces": male_face,
        "female_faces": female_face,
        "eye_glasses": eye_glasses,
        "mustache_faces": Mustache_face,
        "sun_glasses": sun_glasses
    }

    table.put_item(Item=metadata)