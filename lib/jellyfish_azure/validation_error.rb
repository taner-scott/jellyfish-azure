module JellyfishAzure
  class ValidationError < StandardError
    attr_reader :field

    def initialize(message, field = nil)
      super message
      @field = field
    end

#    def to_s
#      if @field
#        "Validation error: #{field}: #{@message}"
#      else
#        "Validation error: #{@message}"
#      end
#    end
  end
end
