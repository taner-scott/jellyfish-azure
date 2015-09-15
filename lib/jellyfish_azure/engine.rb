module JellyfishAzure
  class Engine < ::Rails::Engine
    isolate_namespace JellyfishAzure
	config.autoload_paths += %W(#{config.root}/lib)
    config.generators do |g|
      g.test_framework :rspec, fixture: false
    end

	# Just to make sure the module is loading
	puts "Loading jellyfish-azure..."
  end
end
