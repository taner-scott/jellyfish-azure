require 'ms_rest_azure'
require 'azure_mgmt_storage'
require 'json'

class Service < ActiveRecord::Base
  class StorageAccount < Service::Storage
    def actions
      actions = super.merge :terminate

      # determine if action is available

      actions
    end

    def provision order, product
=begin
  create key_pair name: service.uuid
  create security group (one per project) name: project-{id}
  create vpc (one per project) name: project-{id}
=end
      # Create a client - a point of access to the API and set the subscription id
      client = Azure::ARM::Storage::StorageManagementClient.new(product.provider.credentials)
      client.subscription_id = product.provider.subscriptionId

      # Create a model for new storage account.
      properties = Azure::ARM::Storage::Models::StorageAccountPropertiesCreateParameters.new
      properties.account_type = product.settings[:storage_accountType]

      params = Azure::ARM::Storage::Models::StorageAccountCreateParameters.new
      params.properties = properties
      params.location = order.settings[:location]

      promise = client.storage_accounts.create(order.settings[:resource_group_name], order.settings[:storage_name], params)

      result = promise.value!

      #Handle the result
      storage_account = result.body

      p storage_account.location
      p storage_account.properties.account_type

   rescue Exception => e
      puts "oops " + e.to_s
    end

    def terminate
      puts "terminating..."
    end

  end
end
