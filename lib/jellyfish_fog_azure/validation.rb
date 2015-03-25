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
          valid ? save_images_json(server_list) : valid
          rescue StandardError => e
            valid = false
          ensure
            return valid
        end

        def save_images_json images
          json_array = []
          images.each do |image|
            hash = {
              name: image.name,
              os_type: image.os_type,
              category: image.category
            }
            json_array << hash
          end
          File.open("doc/images.json","w") do |f|
            f.write("\n")
            json_array.each_with_index do |json_image, index|
              f.write(json_image.to_json)
              index == json_array.size - 1 ? f.write("\n") : f.write(",\n")
            end
          end
        end
      end
    end
  end
end
