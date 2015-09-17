class Service < ActiveRecord::Base
  class StorageAccount < Service::Storage
    def provision
=begin
  create key_pair name: service.uuid
  create security group (one per project) name: project-{id}
  create vpc (one per project) name: project-{id}
=end
    end

    def terminate

    end
  end
end
