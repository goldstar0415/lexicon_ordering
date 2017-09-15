class CreateQuantityLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :quantity_levels do |t|
      t.references :product, foreign_key: true
      t.references :user_level, foreign_key: true
      t.integer :min_quantity, default: 0
      t.integer :max_quantity, default: 0
      t.timestamps
    end
  end
end
