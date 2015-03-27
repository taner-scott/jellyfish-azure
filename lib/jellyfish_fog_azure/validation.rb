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
          # Can return nil if no servers are present.
          # Will return an error if the connection is incorrect
          # Ensuring it is a valid test
          server_list.is_a?(Array) || server_list.nil? ? valid = true : valid = false
          valid ? save_images_json(server_list) : valid
          rescue StandardError => e
            valid = false
          ensure
            return valid
        end

        def save_images_json images
          json_array = []
          images.each do |image|
            hash = image.name
            json_array << hash
          end
          file_name = File.expand_path('../../../infrastructure.json', __FILE__)
          json_file = File.read(file_name)
          data_hash = JSON.parse(json_file)
          data_hash['properties']['image']['enum'] = json_array
          File.open(file_name, "w") do |f|
            f.write(data_hash.to_json)
          end
        end
      end
    end
  end
end
