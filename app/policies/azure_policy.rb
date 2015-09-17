class AzurePolicy < ApplicationPolicy
  def azure_locations?
    logged_in?
  end
end
