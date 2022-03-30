data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "../hello-world"
  output_path = "../hello-world.zip"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "lifebit-test-sunny"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "hello-world.zip"
  source = data.archive_file.lambda_hello_world.output_path

  etag = filemd5(data.archive_file.lambda_hello_world.output_path)
}
