module JellyfishAzure
  module Definition
    class WebDevEnvironmentDefinition
      def self.product_questions
        [
          { label: 'Web Technology', name: :az_dev_web, value_type: :string, field: :az_dev_web, required: true },
          { label: 'DB Technology', name: :az_dev_db, value_type: :string, field: :az_dev_db, required: true }
        ]
      end

      def order_questions
        [
          { label: 'Location', name: :az_location, value_type: :string, field: :az_location, required: true },
          { label: 'Web Server DNS Name', name: :az_dev_dns, value_type: :string, field: :text, required: true },
          { label: 'Admin Username', name: :az_username, value_type: :string, field: :text, required: true },
          { label: 'Admin Password', name: :az_password, value_type: :string, field: :password, required: true }
        ]
      end
    end
  end
end
