class Order < ApplicationRecord

  has_many :order_items, dependent: :destroy
  belongs_to :user
  belongs_to :user_level
  
  ransacker :by_product,
    formatter: proc { |product_id|
      results = Order.with_product(product_id).map(&:id)
      results = results.present? ? results : nil
    } do |parent|
    parent.table[:id]
  end
  
  enum status: {success: 0, waiting_approval: 1, rejected: 2}
  
  validates :user, presence: true
  accepts_nested_attributes_for :order_items, :reject_if => lambda{ |a| ((a["quantity"] == "0") || (a["quantity"] == 0)) }
  
  validate :require_atleast_one_order_item
  validate :check_permissible_quantity_limits_on_update
  validate :check_inventory_levels_on_update
  
  # before_create :update_total  
  validate :validate_presence_of_reason_on_rejection
  
  before_create :set_status
  after_create  :notify_through_email
  after_update  :adjust_inventory_levels_on_approval
  after_update  :notify_through_email_on_status_change
    
  private
  
  def check_permissible_quantity_limits_on_update
    if !new_record? && changed_attributes["status"].present? && success?
      order_items.includes(product: [:quantity_levels]).each do |item|
        quantity_level = item.product.quantity_levels.where(user_level_id: user.user_level_id).first
        
        if !quantity_level.duration_per_user.zero?
          duration = (quantity_level.duration_per_user - 1)
          quantity_per_user = quantity_level.quantity_per_user
          orders = user.orders.success.where("created_at >= ?", duration.days.ago.beginning_of_day).includes(:order_items).to_a

          qty_purchased = 0 
          orders.each do |o|
            qty_purchased += o.order_items.sum { |oi| (oi.product_id == item.product_id) ? oi.quantity : 0 }
          end

          if (qty_purchased + item.quantity) > quantity_per_user
            self.errors.add(:base, "#{item.product.name} exceeds the max units allowed in a period.")
          end

        end
        
      end
    end
  end
  
  def check_inventory_levels_on_update
    if !new_record? && changed_attributes["status"].present? && success?
      order_items.includes(:product).each do |item|
        if item.quantity > item.product.quantity_available
          errors.add(:base, "#{item.product.name} inventory is insufficient")
        end
      end
    end
  end
  
  def adjust_inventory_levels_on_approval
    if changes["status"].present? && success?
      order_items.each do |item|
        product = item.product
        product.with_lock do
          product.quantity_available -= item.quantity
          product.save!
        end
      end
    end
  end
  
  def require_atleast_one_order_item
    errors.add(:base, "You must order at least one product") if all_order_items_have_quantity_zero?
  end
  
  def all_order_items_have_quantity_zero?
    !order_items.collect(&:quantity).any? {|i| i > 0}
  end
      
  def validate_presence_of_reason_on_rejection
    if !new_record? && changed_attributes["status"].present? && rejected?
      if reason_for_rejection.blank?
        errors.add(:reason_for_rejection, "must be present.")
      end
    end
  end
    
  def calculate_total
    order_items.sum { |oi| oi.quantity * oi.unit_price  }
  end

  def update_total
    self.total = calculate_total
  end
  
  def set_status
    if order_items.any?(&:high_quantity?)
      self.status = "waiting_approval"
    end
  end
  
  def notify_through_email_on_status_change
    if changes["status"].present?
      notify_through_email
    end
  end
  
  def notify_through_email
    OrderMailer.order_confirmation(self).deliver_now
  end
  
  # active admin filter
  def self.with_product(product_id)
    joins(:order_items).where(order_items: {product_id: product_id} ).where.not(order_items: {quantity: 0})
  end
    
end
