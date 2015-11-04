
module JellyfishAzure
  module Factories
    class DummyService
      attr_accessor :name, :uuid, :status, :status_msg, :service_outputs

      def initialize
        @service_outputs = DummyServiceOutputs.new
      end

      def save
      end

      def save!
      end
    end

    class DummyServiceOutputs
      attr_reader :outputs

      def initialize
        @outputs = []
      end

      def create(values)
        @outputs << values
      end
    end

    FactoryGirl.define do
      factory :service, class: DummyService do
        sequence :name do |n|
          "Service #{n}"
        end

        uuid SecureRandom.uuid
        status :pending
      end
    end
  end
end

