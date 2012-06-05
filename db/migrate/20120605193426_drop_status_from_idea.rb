class DropStatusFromIdea < ActiveRecord::Migration
  def change
  	remove_column :ideas, :status
  end
end
