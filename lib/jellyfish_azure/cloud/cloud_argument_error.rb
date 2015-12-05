module JellyfishAzure
  module Cloud
    class CloudArgumentError < ArgumentError
      attr_reader :field

      def initialize(message, field = nil)
        @field = field
        @message = message
      end

      def to_s
        @message
      end
    end
  end
end
