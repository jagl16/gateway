resource "aws_s3_bucket" "this" {
  count         = 1
  bucket        = var.bucket
  acl           = var.acl
  force_destroy = var.force_destroy

  dynamic "website" {
    for_each = length(keys(var.website)) == 1 ? [var.website] : []

    content {
      index_document = lookup(website.value, "index_document", null)
    }
  }

  tags = var.common_tags
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.attach_policy ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  policy = var.policy
}
