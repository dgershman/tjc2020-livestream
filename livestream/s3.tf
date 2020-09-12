//logging bucket

resource aws_s3_bucket logging_bucket {
  bucket = "livestreaming-logsbucket-1cissxwnrclx8"
  force_destroy = false

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  grant {
    permissions = [
      "READ_ACP",
      "WRITE"
    ]
    type = "Group"
    uri = "http://acs.amazonaws.com/groups/s3/LogDelivery"
  }

  grant {
    id = data.aws_canonical_user_id.current.id
    permissions = [
      "FULL_CONTROL"
    ]
    type = "CanonicalUser"
  }

  grant {
    id = local.cloudfront_canoncial_user_id
    permissions = [
      "FULL_CONTROL"
    ]
    type = "CanonicalUser"
  }
}
//resource aws_s3_bucket recording_bucket {
//  bucket = "my-tf-test-bucket"
//  acl    = "private"
//}
