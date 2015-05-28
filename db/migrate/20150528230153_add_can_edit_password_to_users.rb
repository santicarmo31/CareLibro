class AddCanEditPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_edit_password, :boolean, default: false
  end
end
