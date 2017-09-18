ActiveAdmin.register OrderItem do


  belongs_to :order

  filter :id

  actions :all, :except => [:destroy, :new]


  index :title => proc{
    o = Order.where(id: params[:order_id]).includes(:user, :user_level).first

    "OrderID##{o.id} placed by User: #{o.user.full_name} Level: #{o.user_level.level}"
  } do
    column :name
    column :quantity do |item|
      qty_level = Product.where(id:item.product_id).first.quantity_levels.where(user_level_id: current_user.user_level_id).first
      item.min_qty_level = qty_level.min_quantity
      item.max_qty_level = qty_level.max_quantity
      item.quantity_level = qty_level
      item.set_status
      if item.high_quantity?
        "<div class='tooltip_templates hide'>
            <span id='tooltip_content_info' class='tooltip_content'>
                Minimum allowed value is .
            </span>
            <span id='tooltip_content_info_para' class='tooltip_content'>
                Maximum Quantity is . Ordering more than requires approval after order is placed.
            </span>
        </div>
        <span class='high_quantity' id='quantity_text'>#{item.quantity}</span>
        <input type='text' class='quantity-input' data-tooltip-content='#tooltip_content_info' style='display:none;width:20px;' value=#{item.quantity}
        data-max='#{item.max_qty_level}' data-min='#{item.min_qty_level}' >
        <a href='#' class='edit-quantity-btn' style='float:right'>edit</a>
        <a href='#' class='cancel-quantity-btn' data-id='#{item.id}' data-max='#{item.max_qty_level}'
        data-min='#{item.min_qty_level}' style='display:none;float:right;'>save</a>".html_safe
        # "<input type='text' style='display: none' value=#{item.quantity}><a href='#'>edit</a>".html_safe
      else
        item.quantity
      end
    end
    column :created_at
    column :updated_at

  end
  action_item only: :index do
      accept_link = link_to("Accept", change_status_admin_order_path(order), data: {confirm: "Are you sure?"})
      reject_link = link_to("Reject", edit_admin_order_path(order))
      if order.waiting_approval?
        accept_link + " || " + reject_link
      elsif order.rejected?
        accept_link
      end

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
