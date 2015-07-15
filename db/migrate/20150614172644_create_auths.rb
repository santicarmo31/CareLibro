class CreateAuths < ActiveRecord::Migration
  def change
    create_table :auths do |t|
      t.integer :token
      t.date :expires
      t.integer :user_id

      t.timestamps
    end
  end
end
