class RemoveColumnMinQuantityFromUserLevel < ActiveRecord::Migration[5.0]
  def change
    remove_column :user_levels, :min_quantity
  end
end
