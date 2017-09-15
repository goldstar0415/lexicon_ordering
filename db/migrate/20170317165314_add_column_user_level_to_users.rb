class AddColumnUserLevelToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :user_level, foreign_key: true
  end
end
