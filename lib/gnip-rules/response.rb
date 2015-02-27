include Forwardable

module Gnip
  class Response
    extend Forwardable

    def_delegators :@http_party_response, :response, :request, :body, :headers, :code

    attr_reader :http_party_response

    def initialize(http_party_response)
      @http_party_response = http_party_response
    end

    def rules
      http_party_response["rules"]
    end

    def created?
      code == 201
    end

    def unauthorized?
      code == 401
    end

    def rate_limited?
      code == 429
    end

    def unavailable?
      code == 503
    end

    def bad_request?
      code == 400
    end

    def unprocessable?
      code == 422
    end

    def ok?
      code == 200
    end

    def success?
      ok? || created?
    end

    def error
      http_party_response["error"]
    end

  end
end
