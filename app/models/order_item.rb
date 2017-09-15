class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  
  enum status: {permissible_quantity: 0, high_quantity: 1}

  # validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 1 }
  validate :product_present
  validate :check_min_quantity_critera, on: :create
  validate :check_inventory, on: :create
  validate :check_permissible_quantity_limits, on: :create
  # SKIP checking inventory while user placing order
  # validate :check_inventory, on: :create
  
  delegate :name, to: :product
  
  after_validation :set_status

  # before_save :finalize
  after_commit :adjust_product_inventory, on: :create
  
  attr_accessor :min_qty_level
  attr_accessor :max_qty_level
  attr_accessor :quantity_level, :user

  def unit_price
    product.price
  end

  def total_price
    unit_price * quantity
  end


  private
  
  def check_permissible_quantity_limits
    if errors[:quantity].blank? && quantity_level.present? && !quantity_level.duration_per_user.zero?
      duration = (quantity_level.duration_per_user - 1)
      quantity_per_user = quantity_level.quantity_per_user
      orders = user.orders.success.where("created_at >= ?", duration.days.ago.beginning_of_day).includes(:order_items).to_a

      qty_purchased = 0 
      orders.each do |o|
        qty_purchased += o.order_items.sum { |item| (item.product_id == product_id) ? item.quantity : 0 }
      end
      if (qty_purchased + quantity) > quantity_per_user
        self.errors.add(:quantity, "exceeds the max units allowed in a period. Please decrease the quantity.")
      end

    end
  end
  
  def adjust_product_inventory
    if order.success?
      product.with_lock do
        product.quantity_available -= quantity
        product.save!
      end
    end
  end
  
  def check_inventory
    if errors[:quantity].blank?
      if quantity > product.quantity_available
        self.errors.add(:quantity, "is high.We do not have enough inventory, please decrease the quantity.")
      end
    end
  end
  
  def set_status
    if quantity > max_qty_level
      self.status = "high_quantity"
    else
      self.status = "permissible_quantity"
    end
  end
  
  def check_min_quantity_critera
    if (!quantity.zero? && (quantity < min_qty_level))
      self.errors.add(:quantity, "should be minimum #{min_qty_level}.")
    end
  end
  
  def product_present
    if product.nil?
      errors.add(:product, "is not valid or is not active.")
    end
  end

  def finalize
    self.unit_price = unit_price
    self.total_price = quantity * self.unit_price
  end
end