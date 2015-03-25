module Jellyfish
  module Fog
    module Azure
      class Validation
        # This function will return a true false value based
        # off of whether the credentials provided in the .env file
        # are valid
        def validate
          server_list = Connection.new.connect.list_images
          valid = false
          # puts "Your server list stuff: #{server_list}"
          # Can return nil if no servers are present.
          # Will return an error if the connection is incorrect
          # Ensuring it is a valid test
          server_list.is_a?(Array) || server_list.nil? ? valid = true : valid = false
          rescue StandardError => e
            valid = false
          ensure
            return valid
        end
      end
    end
  end
end
