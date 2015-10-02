class AzurePolicy < ApplicationPolicy
  def azure_locations?
    logged_in?
  end

  def azure_resource_groups?
    logged_in?
  end
end
