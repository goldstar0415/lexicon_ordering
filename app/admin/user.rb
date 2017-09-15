ActiveAdmin.register User do
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
  actions :all, :except => [:destroy, :show]

  filter :email
  filter :first_name
  filter :last_name
  filter :region_id, label: "Region ID"
  filter :region, as: :select, collection: proc { regions }
  filter :territory_id, label: "Territory ID"

  controller do
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :level
    column "Orders Placed" do |u|
      link_to(u.orders.count, admin_orders_path('q[user_id_eq]': u.id))
    end
    column :last_sign_in_at
    actions
  end

  permit_params :email, :password, :password_confirmation, :user_level_id, :first_name, :last_name, :street_address, :city, :state,
  :zip_code, :telephone, :sales_force, :region, :region_id, :territory_name, :territory_id

  form do |f|
    f.inputs "User Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :user_level_id, as: :select, collection: UserLevel.all.collect {|l| [l.level, l.id]}
      f.input :password
      f.input :password_confirmation
      f.input :street_address
      f.input :city
      f.input :state, as: :select, collection: us_states
      f.input :zip_code, input_html: {type: :number}
      f.input :telephone, input_html: {type: :tel}
      f.input :sales_force
      f.input :region, as: :select, collection: regions
      f.input :region_id, label: "Region ID"
      f.input :territory_name
      f.input :territory_id, label: "Territory ID"
    end
    f.actions
  end


end
