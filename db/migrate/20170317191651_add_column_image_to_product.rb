class AddColumnImageToProduct < ActiveRecord::Migration[5.0]

  def up
    add_attachment :products, :image
  end

  def down
    remove_attachment :products, :image
  end
end
