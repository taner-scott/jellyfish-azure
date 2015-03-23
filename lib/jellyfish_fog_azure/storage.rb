module Jellyfish
  module Fog
    module Azure
      class Storage < ::Provisioner
        def provision
          details = order_item.answers
          storage = nil
          name = "storage#{order_item.uuid[0..7]}".delete! '-'
          handle_errors do
            storage = connection.storage_accounts.create(name: name, location: details[:location])
          end
          order_item.provision_status = :ok
          order_item.payload_response = storage.attributes
        end

        def retire
          handle_errors do
            connection.delete_storage_account(attributes[:name])
          end
          order_item.provision_status = :retired
        end

        def attributes
          order_item.payload_response
        end

        def connection
          ::Fog::Compute.new(
            provider: 'Azure',
            azure_sub_id: azure_settings['sub_id'],
            azure_pem: azure_settings['pem_path'],
            azure_api_url: azure_settings['api_url']
          )
        end

        def handle_errors
          yield
        rescue Excon::Errors::BadRequest, Excon::Errors::Forbidden => e
          raise e, 'Bad request. Check for valid credentials and proper permissions.', e.backtrace
        end
      end
    end
  end
end
