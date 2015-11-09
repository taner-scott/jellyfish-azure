module JellyfishAzure
  module Factories
    FactoryGirl.define do
      factory :product, class: OpenStruct do
        skip_create
        settings Hash.new
      end
    end
  end
end
