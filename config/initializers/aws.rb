# Aws.config.update({
#   region: ENV.fetch('AWS_REGION', nil),
#   credentials: Aws::Credentials.new(ENV.fetch('AWS_ACCESS_KEY_ID', nil), ENV.fetch('AWS_SECRET_ACCESS_KEY', nil))
# }
#                  )

# config/initializers/aws.rb

require 'aws-sdk-s3'

Aws.config.update({
  region: ENV['AWS_REGION'] || 'us-east-1', # Default to 'us-east-1' if AWS_REGION is not set
  credentials: Aws::Credentials.new(ENV.fetch('AWS_ACCESS_KEY_ID', nil), ENV.fetch('AWS_SECRET_ACCESS_KEY', nil))
}
                 )
