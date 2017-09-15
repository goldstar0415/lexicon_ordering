class AddColumnsPerUserToQuantityLevel < ActiveRecord::Migration[5.0]
  def change
    add_column :quantity_levels, :quantity_per_user, :integer, default: 0
    add_column :quantity_levels, :duration_per_user, :integer, default: 0
  end
end
