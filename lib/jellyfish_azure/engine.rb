module JellyfishAzure
  class Engine < ::Rails::Engine
    isolate_namespace JellyfishAzure

    config.generators do |g|
      g.test_framework :rspec, fixture: false
    end

    # Initializer to combine this engines static assets with the static assets of the hosting site.
    initializer 'static assets' do |app|
      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
    end

    initializer 'jellyfish_azure.load_registered_providers', :before => :load_config_initializers do
      begin
        if RegisteredProvider.table_exists?
          Dir[File.expand_path '../../../app/models/jellyfish_azure/registered_provider/*', __FILE__].each do |file|
            require_dependency file
          end
        end
      rescue
        # ignored
        nil
      end
    end

    initializer 'jellyfish_azure.load_product_types', :before => :load_config_initializers do
      begin
        if ProductType.table_exists?
          Dir[File.expand_path '../../../app/models/jellyfish_azure/product_type/*.rb', __FILE__].each do |file|
            require_dependency file
          end
        end
      rescue
        # ignored
        nil
      end
    end

    initializer 'jellyfish_azure.register_extension', :after => :finisher_hook do ||
      ::Jellyfish::Extension.register 'jellyfish-azure' do
        requires_jellyfish '>= 4.0.0'
  
        load_scripts 'extensions/azure/components/forms/fields.config.js',
          'extensions/azure/resources/azure-data.factory.js'

        mount_extension JellyfishAzure::Engine, at: :azure
      end
    end
  end
end
