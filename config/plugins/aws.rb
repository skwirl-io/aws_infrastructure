TerraspacePluginAws.configure do |config|
  config.auto_create = true # set to false to completely disable auto creation

  config.s3.encryption = true
  config.s3.enforce_ssl = true
  config.s3.versioning = true
  config.s3.lifecycle = true
  config.s3.access_logging = false # false is the default setting
  config.s3.secure_existing = false # run the security controls on existing buckets. by default, only run on newly created bucket the first time

  config.dynamodb.encryption = true
  config.dynamodb.kms_master_key_id = nil
  config.dynamodb.sse_type = "KMS"
end
