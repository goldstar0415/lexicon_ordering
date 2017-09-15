class AddColumnStatusToOrderItem < ActiveRecord::Migration[5.0]
  def change
    add_column :order_items, :status, :integer, limit: 1, default: 0
  end
end
