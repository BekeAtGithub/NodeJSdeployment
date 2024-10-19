variable "bucket_name" {
  description = "Remote S3 Bucket Name"
  type        = string
  validation {
    condition     = can(regex("^([a-z0-9]{1}[a-z0-9-]{1,61}[a-z0-9]{1})$", var.bucket_name))
    error_message = "Bucket name must follow S3 name rules"
  }
}

variable "table_name" {
  description = "Remote DynamoDB Table Name"
  type        = string
}