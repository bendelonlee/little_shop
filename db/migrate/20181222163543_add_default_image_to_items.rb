class AddDefaultImageToItems < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :image, :string, null: false, :default => "/default_image.jpg"
  end
end
