module JellyfishAzure
  module Product
    class WebDevEnvironment < ::Product
      def order_questions
        [
          { label: 'Location', name: :az_dev_location, value_type: :string, field: :az_dev_location, required: true },
          { label: 'Web Server DNS Name', name: :az_dev_dns, value_type: :string, field: :text, required: true },
          { label: 'Admin Username', name: :az_username, value_type: :string, field: :text, required: true },
          { label: 'Admin Password', name: :az_password, value_type: :string, field: :password, required: true }
        ]
      end

      def service_class
        'JellyfishAzure::Service::WebDevEnvironment'.constantize
      end
    end
  end
end

