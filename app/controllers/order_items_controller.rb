class OrderItemsController < ApplicationController

  # before_action :authenticate_user!

  # api :PUT, 'order_items/update:id', 'Updates a given Item owned by authenticated user'

  def update_item
    p params[:quantity]
    @orderItem = OrderItem.find_by!(id: params[:id])
    if @orderItem.present?
      qty_level = Product.where(id:@orderItem.product_id).first.quantity_levels.where(user_level_id: current_user.user_level_id).first
      @orderItem.min_qty_level = qty_level.min_quantity
      @orderItem.max_qty_level = qty_level.max_quantity
      @orderItem.quantity_level = qty_level
      @orderItem.update(quantity: params[:quantity])
        render json: {quantity: @orderItem.quantity}
    end
  end
end
