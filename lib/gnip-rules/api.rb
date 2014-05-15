module Gnip
  module API
    def add(rules)
      options = ActiveSupport::JSON.encode( {:rules => rules} )
      puts options
      Gnip::Response.new self.class.post('/rules.json', :body => options, :timeout => 60 )
    end

    def remove( rules )
      options = ActiveSupport::JSON.encode( {:rules => rules} )
      Gnip::Response.new self.class.delete('/rules.json', :body => options, :timeout => 60 )
    end

    def list
      Gnip::Response.new self.class.get( '/rules.json', :timeout => 60 )
    end

    def delete_all!
      rules = self.list.rules
      sleep 3
      self.remove( rules )
    end

  end
end
