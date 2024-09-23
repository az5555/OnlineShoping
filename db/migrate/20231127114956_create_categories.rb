class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :type_name
      t.integer :weight, default: 0
      t.integer :counter, default: 0
      t.timestamps
    end

    add_index :categories, [:type_name]
  end
end
