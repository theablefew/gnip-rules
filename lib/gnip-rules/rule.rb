module Gnip
  class Rule

    attr_accessor :value, :tag, :errors

    def initialize( v , t = nil )
      @value = v
      @tag = t
      @errors = []
    end

    def as_json(options={})
      o = {"value" => value}
      o.merge!( "tag" => tag ) unless tag.nil?
      return o
    end

    def valid?
      validate_length
    end

    private

    def validate_length
      if @value.length > 1024
        @errors << "Too many characters in rule - #{@value.length}. The maximum allowed is 1024"
        return false
      end
      return true
    end

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
