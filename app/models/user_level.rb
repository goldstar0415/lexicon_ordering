class UserLevel < ApplicationRecord
  
  has_many :users
  has_many :orders
  has_many :quantity_levels
  
  validates :level, presence: true, uniqueness: true
  
  def product_order_count(product)
    product_count = 0
    orders.includes(:order_items).each do |o|
      item = o.order_items.find {|oi| oi.product_id == product.id }
      if item
        product_count += item.quantity
      end
    end
    product_count
  end
  
  def name
    level
  end
end
