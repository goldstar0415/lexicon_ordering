class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.decimal :total, precision: 12, scale: 3

      t.timestamps
    end
  end
end
