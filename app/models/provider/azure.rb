class Provider < ActiveRecord::Base
  class Azure < Provider
    def azure_locations
      [ "eastus", "centralus", "westus" ]
    end
  end
end
