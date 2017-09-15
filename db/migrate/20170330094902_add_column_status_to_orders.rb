class AddColumnStatusToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :status, :integer, limit: 1, default: 0
  end
end
