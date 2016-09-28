module Gnip
  module API
    #
    # parsed_response={"summary"=>{"created"=>1, "not_created"=>0},
    # "detail"=>[{"rule"=>{"value"=>"larlygag", "tag"=>"tv:game_of_thrones", "id"=>781219849804533760}, "created"=>true}], 
    # "sent"=>"2016-09-28T19:51:41.257Z"}`
    #
    #

    def add(rules)
      options = ActiveSupport::JSON.encode( {rules: rules} )
      Gnip::Response.new self.class.post('', body: options)
    end

    def remove( rules )
      options = ActiveSupport::JSON.encode( {rules: rules} )
      Gnip::Response.new self.class.post('?_method=delete', body: options)
    end

    def list
      Gnip::Response.new self.class.get('')
    end

    def delete_all!
      rules = self.list.rules
      sleep 3
      self.remove( rules )
    end

  end
end
