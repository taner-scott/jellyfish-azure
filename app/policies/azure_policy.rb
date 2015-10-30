class AzurePolicy < ApplicationPolicy
  def locations?
    logged_in?
  end

  def parameter_values?
    logged_in?
  end
end
