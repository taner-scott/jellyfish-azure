class AzurePolicy < ApplicationPolicy
  def parameter_values?
    logged_in?
  end

  def web_dev_locations?
    logged_in?
  end
end
