require 'active_support'
require 'httparty'
require 'json'

require 'gnip-rules/api'
require 'gnip-rules/validation_response'
require 'gnip-rules/rule'


module Gnip
  class Validation
    include HTTParty

    headers 'Accept' => 'application/json', 'Content-Type' => 'application/json'
    format :json

    #debug_output $stdout

    def initialize( configuration = nil, username = nil, password = nil, uri = nil, timeout = 60 )
      @configuration_file = configuration
      unless username && password && uri
        load_credentials!
        username = @config["username"]
        password = @config["password"]
        uri = uri || @config["validation_url"]
      end

      self.class.basic_auth username , password
      self.class.base_uri uri
      self.class.default_timeout timeout
    end

    def default_timeout(timeout)
      self.class.default_timeout timeout
      self.class.default_options
    end

    def validate(rules)
      options = ActiveSupport::JSON.encode( {rules: rules} )
      Gnip::ValidationResponse.new self.class.post('', body: options)
    end

    private

    def load_credentials!
      if File.exists?( @configuration_file )
         @config = YAML.load_file( @configuration_file )[environment.to_s]
      else
        raise Exception.new( <<-RUBY
          You must provide a configuration file at config/gnip.yml

            development: &development
              username: omg@omg.com
              password: your_password
              account: your_account
              streaming_url: 'https://gnip-stream.twitter.com/stream/powertrack/accounts/YOUR_ACCOUNT/publishers/twitter/Sandbox.json'
              rules_api: 'https://gnip-api.twitter.com/rules/powertrack/accounts/YOUR_ACCOUNT/publishers/twitter/Sandbox.json'
              validation_url: 'https://gnip-api.twitter.com/rules/powertrack/accounts/<accountName>/<streamLabel>/validation.json'

        RUBY
        )
      end
    end

    def environment
      if defined?(Rails)
        Rails.env
      elsif defined?(RAILS_ENV)
        RAILS_ENV
      elsif defined?(RACK_ENV)
        RACK_ENV
      else
        :development
      end
    end
  end
end
