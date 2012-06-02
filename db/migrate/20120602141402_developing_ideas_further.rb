class DevelopingIdeasFurther < ActiveRecord::Migration
  def change
    add_column :ideas, :pitch, :text
    add_column :ideas, :status, :text
    remove_column :ideas, :priority
  end
end
