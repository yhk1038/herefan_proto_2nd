CarrierWave.configure do |config|
    host = 's3-' + ENV['AWS_REGION'] + '.amazonaws.com'
    
    config.fog_provider = 'fog/aws'                        # required
    config.fog_credentials = {
            provider:              'AWS',                        # required
            aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],     # required
            aws_secret_access_key: ENV['AWS_ACCESS_KEY_SECRET'], # required
            region:                ENV['AWS_REGION'],            # optional, defaults to 'us-east-1'
            host:                  host,
            endpoint:              'https://' + host
    }
    config.fog_directory  = 'herefan'        # required
end
