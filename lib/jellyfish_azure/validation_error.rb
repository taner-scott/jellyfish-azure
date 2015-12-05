module JellyfishAzure
  class ValidationError < StandardError
    attr_reader :field

    def initialize(message, field = nil)
      super message
      @field = field
    end
  end
end
