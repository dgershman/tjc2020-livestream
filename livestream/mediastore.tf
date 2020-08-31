data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource aws_media_store_container media_store_container {
  name = var.media_store_container_name
}

resource aws_media_store_container_policy media_store_container_policy {
  container_name = aws_media_store_container.media_store_container.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "MediaStoreFullAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "mediastore:*",
      "Resource": "arn:aws:mediastore:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:container/${var.media_store_container_name}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "true"
        }
      }
    },
    {
      "Sid": "PublicReadOverHttps",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "mediastore:GetObject",
        "mediastore:DescribeObject"
      ],
      "Resource": "arn:aws:mediastore:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:container/${var.media_store_container_name}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "true"
        }
      }
    }
  ]
}
EOF
}
