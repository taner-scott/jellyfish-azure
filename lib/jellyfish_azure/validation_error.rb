module JellyfishAzure
  class ValidationError < StandardError
    attr_reader :field

    def initialize(message, field = nil)
      @field = field
      @message = message
    end

    def to_s
      if @field
        "Validation error: #{field}: #{@message}"
      else
        "Validation error: #{@message}"
      end
    end
  end
end
