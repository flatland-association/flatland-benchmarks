import os

AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID", False)
AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY", False)
AWS_ENDPOINT_URL = os.getenv("AWS_ENDPOINT_URL", None)
AI4REALNET_S3_UPLOAD_ROOT = os.getenv("AI4REALNET_S3_UPLOAD_ROOT", "ai4realnet/submissions/")

S3_BUCKET = os.getenv("S3_BUCKET", "aicrowd-production")


class s3_utils:

  @staticmethod
  def upload_to_s3(localpath, relative_upload_key, s3_bucket=S3_BUCKET, ):
    s3 = s3_utils.get_boto_client()
    if not s3_bucket:
      raise Exception("S3_BUCKET not provided...")

    file_target_key = AI4REALNET_S3_UPLOAD_ROOT + relative_upload_key
    s3.put_object(
      Bucket=s3_bucket,
      Key=file_target_key,
      Body=open(localpath, 'rb')
    )
    return file_target_key

  @staticmethod
  def get_boto_client(aws_access_key_id=AWS_ACCESS_KEY_ID, aws_secret_access_key=AWS_SECRET_ACCESS_KEY, aws_endpoint_url=AWS_ENDPOINT_URL):
    if not aws_access_key_id or not aws_secret_access_key:
      raise Exception("AWS Credentials not provided..")
    try:
      import boto3  # type: ignore
    except ImportError:
      raise Exception(
        "boto3 is not installed. Please manually install by : ",
        " pip install -U boto3"
      )

    return boto3.client(
      's3',
      # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/core/session.html
      endpoint_url=aws_endpoint_url,
      aws_access_key_id=aws_access_key_id,
      aws_secret_access_key=aws_secret_access_key
    )

  @staticmethod
  def is_aws_configured():
    if not AWS_ACCESS_KEY_ID or not AWS_SECRET_ACCESS_KEY:
      return False
    else:
      return True
