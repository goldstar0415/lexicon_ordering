ActiveAdmin.register OrderItem do
  
  belongs_to :order
  
  filter :id
  
  actions :all, :except => [:destroy]
  
  index :title => proc{ 
    o = Order.where(id: params[:order_id]).includes(:user, :user_level).first
    "OrderID##{o.id} placed by User: #{o.user.full_name} Level: #{o.user_level.level}"
  } do
    column :name
    column :quantity do |item|
      if item.high_quantity?
        "<span class='high_quantity'>#{item.quantity}</span> <a href='#'>edit</a>".html_safe
      else
        item.quantity
      end
    end
    column :created_at
    column :updated_at
  end
  
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end
