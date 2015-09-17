class Provider < ActiveRecord::Base
  class Azure < Provider
    def azure_locations
      [
        { label: "US East", value: "eastus" },
        { label: "US West", value: "westus" }
      ]
    end
  end
end
