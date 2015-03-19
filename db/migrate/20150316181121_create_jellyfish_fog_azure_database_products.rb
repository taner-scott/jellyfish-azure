class CreateJellyfishFogAzureDatabaseProducts < ActiveRecord::Migration
  def change
    create_table :jellyfish_fog_azure_database_products do |t|
      t.timestamp :timestamp
      t.string :location
    end
  end
end
