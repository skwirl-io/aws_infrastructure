ENV['TS_ENV'] ||= 'staging'

ENV['AWS_PROFILE'] = ENV['TS_ENV'] == 'production' ? 'production' : 'default'
ENV['AWS_REGION'] ||= 'us-east-1'
