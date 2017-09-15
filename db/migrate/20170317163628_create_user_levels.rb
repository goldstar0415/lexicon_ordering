class CreateUserLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :user_levels do |t|
      t.integer :level
      t.integer :min_quantity, default: 0
      t.timestamps
    end
  end
end
