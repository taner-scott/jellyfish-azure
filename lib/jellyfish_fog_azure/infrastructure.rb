module Jellyfish
  module Fog
    module Azure
      class Infrastructure < ::Provisioner
        def provision
          details = order_item.answers
          server = nil
          handle_errors do
            server = connection.servers.create(details)
          end
          order_item.provision_status = :ok
          order_item.payload_response = server.attributes
        end

        def connection
          ::Fog::Compute.new(
            provider: 'Azure',
            azure_sub_id: azure_settings[:sub_id],
            azure_pem: azure_settings[:pem_path],
            azure_api_url: azure_settings[:api_url]
          )
        end

        def retire
          handle_errors do
            connection.delete_virtual_machine(server_attributes[:vm_name], server_attributes[:cloud_service_name])
          end
          order_item.provision_status = :retired
        end

        def server_attributes
          order_item.payload_response
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
