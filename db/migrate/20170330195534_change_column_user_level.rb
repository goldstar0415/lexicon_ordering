class ChangeColumnUserLevel < ActiveRecord::Migration[5.0]
  def change
    change_column :user_levels, :level, :string, limit: 30
  end
end
