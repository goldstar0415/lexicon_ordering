class ChangesToUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :territory_alignment, :territory_name
    remove_column :users, :employee_id
  end
end
