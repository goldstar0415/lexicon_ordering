class AddColumnUserLevelIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :user_level, foreign_key: true
  end
end
