require 'active_support'
require 'httparty'
require 'json'

require 'gnip-rules/api'
require 'gnip-rules/response'
require 'gnip-rules/rule'

module Gnip
  class Rules
    include HTTParty
    include Gnip::API

    debug_output $stdout

    headers 'Accept' => 'application/json', 'Content-Type' => 'application/json'
    format :json

    def initialize( configuration = nil, username = nil, password = nil, uri = nil, timeout = 60 )
      @configuration_file = configuration
      unless username && password && uri
        load_credentials!
        username = @config["username"]
        password = @config["password"]
        uri = uri || @config["rules_url"]
      end

      self.class.basic_auth username , password
      self.class.base_uri uri
      self.class.default_timeout timeout
    end

    def default_timeout(timeout)
      self.class.default_timeout timeout
      self.class.default_options
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
