module JellyfishAzure
  class Engine < ::Rails::Engine
    isolate_namespace JellyfishAzure

    config.generators do |g|
      g.test_framework :rspec, fixture: false
    end

    # Just to make sure the module is loading
    puts "Loading jellyfish-azure..."

    # Initializer to combine this engines static assets with the static assets of the hosting site.
    initializer 'static assets' do |app|
      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
    end

    initializer 'jellyfish_azure.load_registered_providers', :before => :load_config_initializers do
      begin
          puts "Loading asdf " + __FILE__
        if RegisteredProvider.table_exists?
          puts "Loading " + __FILE__
          Dir[File.expand_path "../../../app/models/registered_provider/*", __FILE__].each do |file|
            puts "sdfasdf"
            require_dependency file
          end
        end
      rescue
        #ignored
        nil
      end
    end

    initializer 'jellyfish_azure.register_extension', :after => :finisher_hook do |app|
      Jellyfish::Extension.register 'jellyfish-azure' do
        requires_jellyfish '>= 4.0.0'

        load_scripts 'extensions/azure/components/forms/fields.config.js',
          'extensions/azure/resources/azure-data.factory.js'

        mount_extension JellyfishAzure::Engine, at: :azure
      end
    end
  end
end
