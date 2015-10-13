class AzurePolicy < ApplicationPolicy
  def web_dev_locations?
    logged_in?
  end
end
