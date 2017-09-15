ActiveAdmin.register UserLevel do
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

config.filters = false

actions :all, :except => [:destroy]

index do
  selectable_column
  column :level
  actions
  column "Orders" do |ul|
    link_to("view", admin_orders_path('q[user_level_id_eq]': ul.id))
  end  
end

permit_params :level

end
