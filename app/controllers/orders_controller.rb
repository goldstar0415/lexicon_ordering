class OrdersController < ApplicationController
  # http_basic_authenticate_with name: "safe", password: "qwerty!@"
  
  layout false
  
  before_action :authenticate_user!
  
  def new
    @order = current_user.orders.build(user_level: current_user.user_level)
    preload_order_items
  end

  def create
    @order = current_user.orders.build order_params
    sanitize_order
    
    if @order.save
      redirect_to "/pages/order_success?order_id=#{@order.id}"
    else
      preload_order_items
      render :new
    end
  end
  
  private
  
  def preload_order_items
    Product.publishable.includes(:quantity_levels).each do |pr| 
      qty_level = pr.quantity_levels.find {|l| l.user_level_id == current_user.user_level_id}
      order_item = @order.order_items.find {|i| i.product_id == pr.id}
      if order_item.present?
        order_item.min_qty_level = qty_level.min_quantity
        order_item.max_qty_level = qty_level.max_quantity
      else
        # don't include products with user level max quantity set to 0
        next if qty_level.max_quantity.zero?
        @order.order_items.build(product: pr, quantity: 0, min_qty_level: qty_level.min_quantity, max_qty_level: qty_level.max_quantity)
      end
    end
  end
  
  def order_params
    params.require(:order).permit(:user_level_id, order_items_attributes: [:product_id, :quantity, :min_qty_level, :max_quantity_level])
  end
  
  def sanitize_order
    @order.order_items.each do |item| 
      qty_level = Product.where(id:item.product_id).first.quantity_levels.where(user_level_id: current_user.user_level_id).first
      item.min_qty_level = qty_level.min_quantity
      item.max_qty_level = qty_level.max_quantity
      item.quantity_level = qty_level
      item.user = current_user
      # if item.quantity.blank?
      #   item.quantity = qty_level.min_quantity
      # end
    end
  end
  
end
