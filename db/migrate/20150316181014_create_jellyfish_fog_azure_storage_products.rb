class CreateJellyfishFogAzureStorageProducts < ActiveRecord::Migration
  def change
    create_table :jellyfish_fog_azure_storage_products do |t|
      t.timestamp :timestamp
      t.string :location
    end
  end
end
