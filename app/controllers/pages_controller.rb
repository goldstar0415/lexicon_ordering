class PagesController < ApplicationController
  # http_basic_authenticate_with name: "safe", password: "qwerty!@"
  
  def home
    
  end
  
  def order_success
    @order = Order.where(id: params[:order_id]).first
  end
end
