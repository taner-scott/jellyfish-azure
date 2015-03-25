module Jellyfish
  module Fog
    module Azure
      class Databases < ::Provisioner
        def provision
          details = order_item.answers
          server = nil
          password = SecureRandom.hex[0...9]
          handle_errors do
            server = connection.databases.create('admin', password, details['location'])
          end
          order_item.provision_status = :ok
          order_item.payload_response = server.instance_values.merge(password: password)
        end

        def retire
          name = order_item.payload_response[:name]
          handle_errors do
            connection.delete_database(name)
          end
          order_item.provision_status = :retired
        end

        def connection
          Connection.new.connect
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
