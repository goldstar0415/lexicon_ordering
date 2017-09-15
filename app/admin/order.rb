ActiveAdmin.register Order do
  
  scope :success, :default => true
  scope :waiting_approval, default: true
  scope :rejected
  
  filter :id
  filter :user
  filter :user_level
  filter :by_product_in,
    :as => :select,
    :label => 'Resource',
    :collection => proc { Product.order(:name) }
  
  
  actions :all, :except => [:destroy, :new]
  
  csv do
    column("Order ID") { |o| o.id }
    column('User Name') { |o| o.user.full_name }
    column('User Level') { |o| o.user_level.level }
    column('Email') { |o| o.user.email }
    column('Shipping Info') { |o| o.user.full_address_csv }
    column('Resources') { |o| o.order_items.collect {|i| "#{i.name} - Quantity: #{i.quantity}"}.join(", ") }
    column('Total Resources') { |o| o.order_items.sum(&:quantity) }
    column('Date Created') { |o| o.created_at }
  end
  
  controller do
    def update
      update! {admin_orders_path(scope: 'waiting_approval')}
    end
  end
  
  index do
    selectable_column
    id_column
    column :user
    column "Resources" do |order|
      link_to("view", admin_order_order_items_path(order))
    end
    column :created_at
    if params[:scope].present? && (params[:scope] != "success")
      column "Controls" do |o|
        accept_link = link_to("Accept", change_status_admin_order_path(o), data: {confirm: "Are you sure?"})
        reject_link = link_to("Reject", edit_admin_order_path(o))
        if o.waiting_approval?
          accept_link + " || " + reject_link
        elsif o.rejected?
          accept_link
        end
      end
    end
  end
  
  member_action :change_status, method: :get do
    resource.status = "success"
    if resource.save
      msg = "Order##{resource.id}"
      flash["notice"] = "#{msg} status has been updated !"
    else
      flash["error"] = "FAILED: " + resource.errors.full_messages.join(", ")
    end
    redirect_back(fallback_location: "/admin")
  end
  
  
  permit_params :reason_for_rejection, :status

  form do |f|
    f.inputs "Order Rejection Details" do
      f.input :reason_for_rejection, as: :text, input_html: {required: true, value: "Sorry your order has been rejected for the following reason:"}
      f.input :status, input_html: {value: 'rejected', required: true}, as: :hidden
    end
    f.actions
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
