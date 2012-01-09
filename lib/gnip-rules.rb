require 'active_support'
require 'httparty'
require 'json'

module Gnip
  class Rules
    include HTTParty

    headers 'Accept' => 'application/json', 'Content-Type' => 'application/json'
    format :json

    def initialize( username = nil, password = nil, uri = nil )
      unless username && password && uri
        load_credentials!
        username = @config["username"]
        password = @config["password"]
        uri = @config["streaming_url"]
      end

      self.class.basic_auth username , password 
      self.class.base_uri uri
    end

    def add(rules)
      options = ActiveSupport::JSON.encode( {:rules => rules} )
      puts options
      self.class.post('/rules.json', :body => options )
    end

    def remove( rules )
      options = ActiveSupport::JSON.encode( {:rules => rules} )
      self.class.delete('/rules.json', :body => options )
    end

    def list
      self.class.get( '/rules.json' )
    end

    def delete_all!
      rules = self.list["rules"]
      self.remove( rules )
    end

    private

    def load_credentials!
      if File.exists?( 'config/gnip.yml' )
         @config = YAML.load_file( "config/gnip.yml" )[environment.to_s]
      else
        raise Exception.new( <<-RUBY
          You must provide a configuration file at config/gnip.yml

            development: &development
              username: omg@omg.com 
              password: larl! 
              account: larloperator
              streaming_url: 'https://stream.gnip.com:443/accounts/YOUR_ACCOUNT/publishers/twitter/streams/track/prod/'

        RUBY
        )
      end
    end

    def environment
      #Clearly there's a better way. 
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

    # -Rules
  end

  class Rule
    attr_accessor :value, :tag, :errors

    def initialize( v , t = nil )
      @value = v
      @tag = t
      @errors = []
    end
    
    def to_json
      o = {"value" => value}
      o.merge!( "tag" => tag ) unless tag.nil?
      JSON.generate( o )
    end

    def valid?
      valid = validate_phrase_count
      # raise "Invalid rule #{self.errors.join('\n')}" unless valid
    end

    private

    def validate_phrase_count
     phrases = @value.scan( /(\"[\w\-\s]+\"|\w+\s?)/ ).count
     if phrases > 10
       @errors << "Too many clauses in phrase - #{phrases}.  The maximum allowed is 10"
       return false
     end
     return true
    end

  end
end
