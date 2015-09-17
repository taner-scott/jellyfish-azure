class RegisteredProvider < ActiveRecord::Base
  class Azure < RegisteredProvider
    def self.load_registered_providers
      return unless super
      transaction do
        [
          set('Azure', 'ea9db5ef-c0fd-458e-95c4-5005517b2bf6')
        ].each { |s| create! s.merge!(type: 'RegisteredProvider::Azure') }
      end
    end

    def provider_class
      'Provider::Azure'.constantize
    end

    def description
      'Azure'
    end

    def tags
      ['azure']
    end

    def questions
      [
        { name: :client_id, value_type: :string, field: :text, label: 'Client ID', required: true },
        { name: :client_secret, value_type: :password, field: :password, label: 'Client Secret', required: :if_new }
        #{ name: :region, value_type: :string, field: :aws_regions, required: true }
      ]
    end
  end
end
