// TODO: create s3 user for downloading recordings

resource aws_iam_role medialive_access_role {
  name               = "MediaLiveAccessRole"
  description        = "AWS Elemental MediaLive role."
  assume_role_policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "medialive.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource aws_iam_role_policy medialive_access_role_policy {
  name   = "MediaLiveCustomPolicy"
  role   = aws_iam_role.medialive_access_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "mediastore:ListContainers",
                "mediastore:PutObject",
                "mediastore:GetObject",
                "mediastore:DeleteObject",
                "mediastore:DescribeObject"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "mediaconnect:ManagedDescribeFlow",
                "mediaconnect:ManagedAddOutput",
                "mediaconnect:ManagedRemoveOutput"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:describeSubnets",
                "ec2:describeNetworkInterfaces",
                "ec2:createNetworkInterface",
                "ec2:createNetworkInterfacePermission",
                "ec2:deleteNetworkInterface",
                "ec2:deleteNetworkInterfacePermission",
                "ec2:describeSecurityGroups"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "mediapackage:DescribeChannel"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource aws_iam_policy custodian_policy {
  name   = "StreamingCustodianPolicy"
  policy = data.aws_iam_policy_document.custodian_policy.json
}

data aws_iam_policy_document custodian_policy {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:HeadBucket",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.recording_bucket.arn}/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.recording_bucket.arn,
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "medialive:ListChannels",
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "medialive:StartChannel",
      "medialive:StopChannel",
      "medialive:BatchStart",
      "medialive:BatchStop",
    ]
    resources = [
      "arn:aws:medialive:us-east-1:846656992549:*",
    ]
  }
}
