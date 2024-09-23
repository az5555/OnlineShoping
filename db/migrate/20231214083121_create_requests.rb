class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.integer :user_id
      t.string :username
      t.timestamps
    end
  end
end
