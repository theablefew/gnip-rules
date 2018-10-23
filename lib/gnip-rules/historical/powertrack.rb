require 'active_support'
require 'httparty'
require 'json'

require 'gnip-rules/api'
require 'gnip-rules/validation_response'
require 'gnip-rules/rule'

module Gnip
  module Historical
    class Powertrack
      include HTTParty

      headers 'Accept' => 'application/json', 'Content-Type' => 'application/json'
      format :json

    #debug_output $stdout

      JOB_URL_PATH = "/jobs"
      JOBS_URL_PATH = "/jobs"

      def initialize( configuration = nil, username = nil, password = nil, uri = nil, timeout = 60 )
        @configuration_file = configuration
        unless username && password && uri
          load_credentials!
          username = @config["username"]
          password = @config["password"]
          uri = uri || @config["historical_powertrack_url"]
        end

        self.class.basic_auth username , password
        self.class.base_uri uri
        self.class.default_timeout timeout
      end

      def default_timeout(timeout)
        self.class.default_timeout timeout
        self.class.default_options
      end

      def job(uuid)
        self.class.get "#{JOB_URL_PATH}/#{uuid}"
      end

      def create(opts)
        #dataFormat: 'original'
        #fromDate: 201808280000
        #toDate: 201808290000
        #title: 'Spencer Test DO NOT RUN'
        #rules: []
        job_opts =  ActiveSupport::JSON.encode( opts.merge!({publisher: 'twitter', streamType: 'track_v2', dataFormat: 'activity_streams'}) )
        self.class.post(JOBS_URL_PATH, body: job_opts)
      end

      def jobs
        self.class.get JOBS_URL_PATH
      end

      def accept(uuid)
        opts = ActiveSupport::JSON.encode( {status: 'accept'} )
        self.class.put "#{JOB_URL_PATH}/#{uuid}", body: opts
      end

      def reject(uuid)
        opts = ActiveSupport::JSON.encode( {status: 'reject'} )
        self.class.put "#{JOB_URL_PATH}/#{uuid}", body: opts
      end

      def get_results(uuid)
        self.class.get "#{JOB_URL_PATH}/#{uuid}/results"
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
end
