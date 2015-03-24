module Jellyfish
  module Fog
    module Azure
      class Validation
        # This function will return a true false value based
        # off of whether the credentials provided in the .env file
        # are valid
        def validate
          begin
            server_list = Connection.new.connect.servers.all
            # Can return nil if no servers are present.
            # Will return an error if the connection is incorrect
            # Ensuring it is a valid test
            server_list.kind_of?(Array) || server_list.nil? ? true : false
          rescue StandardError => e
              false
          end
        end
      end
    end
  end
end
