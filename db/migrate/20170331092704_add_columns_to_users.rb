class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string, limit: 100
    add_column :users, :last_name, :string, limit: 100
    add_column :users, :street_address, :string
    add_column :users, :city, :string, limit: 100
    add_column :users, :state, :string, limit: 10
    add_column :users, :zip_code, :string, limit: 10
    add_column :users, :telephone, :string, limit: 20
    add_column :users, :sales_force, :string, limit: 10
    add_column :users, :region, :string, limit: 30
    add_column :users, :region_id, :string, limit: 30
    add_column :users, :territory_alignment, :string, limit: 100
    add_column :users, :territory_id, :string, limit: 10
    add_column :users, :employee_id, :string, limit: 10
  end
end
