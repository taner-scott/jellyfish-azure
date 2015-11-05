
module JellyfishAzure
  module Factories
    FactoryGirl.define do
      factory :service_outputs, class: OpenStruct do
        skip_create

        outputs []

        after(:create) do |obj, evaluator|
          def obj.create(values)
            outputs << values
          end
        end
      end

      factory :service, class: OpenStruct do
        skip_create

        sequence :name do |n|
          "Service #{n}"
        end

        uuid SecureRandom.uuid
        status :pending
        settings Hash.new
        service_outputs

        after(:create) do |obj, evaluator|
          def obj.save
          end
        end
      end
    end
  end
end

