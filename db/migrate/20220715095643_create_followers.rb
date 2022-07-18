class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.integer :follower_user_id
      t.references :user

      t.timestamps
    end
    add_index :followers, :user_id
  end
end
