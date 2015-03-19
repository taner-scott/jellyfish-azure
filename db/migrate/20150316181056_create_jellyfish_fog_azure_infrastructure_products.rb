class CreateJellyfishFogAzureInfrastructureProducts < ActiveRecord::Migration
  def change
    create_table :jellyfish_fog_azure_infrastructure_products do |t|
      t.timestamp :timestamp
      t.string :location
      t.string :image
      t.string :name
      t.string :storage_account
    end
  end
end
