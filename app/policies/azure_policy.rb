class AzurePolicy < ApplicationPolicy
  def azure_locations?
    any_user!
  end
end
