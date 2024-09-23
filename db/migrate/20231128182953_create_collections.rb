class CreateCollections < ActiveRecord::Migration[7.1]
  def change
    create_table :collections do |t|
      t.integer :user_id
      t.integer :product_id

      t.timestamps
    end


    add_index :collections, [:user_id]
  end
end
