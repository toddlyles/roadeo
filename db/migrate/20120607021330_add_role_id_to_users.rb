class AddRoleIdToUsers < ActiveRecord::Migration
  def change
  	add_column :Users, :role_id, :integer
  end
end
