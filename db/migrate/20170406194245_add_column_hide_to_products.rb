class AddColumnHideToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :published, :boolean, default: true
  end
end
