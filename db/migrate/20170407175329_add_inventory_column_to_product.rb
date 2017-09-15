class AddInventoryColumnToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :quantity_available, :integer, default: 0
  end
end
