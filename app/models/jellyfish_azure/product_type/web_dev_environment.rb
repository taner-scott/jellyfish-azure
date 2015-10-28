module JellyfishAzure
  module ProductType
    class WebDevEnvironment < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Web Development Environment with Database', '2a02e79e-9e07-4076-8524-227d8999c32', provider_type: 'JellyfishAzure::Provider::Azure')
          ].each do |s|
            create! s.merge!(type: 'JellyfishAzure::ProductType::WebDevEnvironment')
          end
        end
      end

      def description
        'A web server with a database on a private network. A choice is given for the web and database technologies'
      end

      def tags
        %w(storage cdn)
      end

      def product_questions
        [
          { label: 'Web Technology', name: :az_dev_web, value_type: :string, field: :az_dev_web, required: true },
          { label: 'DB Technology', name: :az_dev_db, value_type: :string, field: :az_dev_db, required: true }
        ]
      end

      def product_class
        'JellyfishAzure::Product::WebDevEnvironment'.constantize
      end
    end
  end
end
