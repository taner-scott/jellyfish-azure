class Provider < ActiveRecord::Base
  class Azure < Provider
    def azureLocations
      [ "eastus", "centralus", "westus" ]
    end
  end
end
