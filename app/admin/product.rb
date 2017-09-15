ActiveAdmin.register Product, as: "Resource" do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

  actions :all, except: [:destroy, :show]
  
  filter :name
  
  permit_params :name, :published, :quantity_available, :description, :image, 
                quantity_levels_attributes: [:product_id, :user_level_id, :min_quantity, :max_quantity, :id, :duration_per_user, :quantity_per_user]
  
  controller do
    def new 
      super do |format|
        UserLevel.all.each do |ul|
          resource.quantity_levels.build(user_level_id: ul.id)
        end
      end
    end

    def create
      super do |format|
        if !resource.new_record?
          flash["notice"] = "Resource was successfully created."
        end
      end
    end
    
    def update
      super do |format|
        if resource.errors.blank?
          flash["notice"] = "Resource was successfully updated."
        end
      end
    end
  end
  
  index do
    id_column
    column :name
    column :published
    column :quantity_available
    column "User Levels" do |product|
      columns do
        column { "<strong><u>Level</u></strong>".html_safe }
        column { "<strong><u>Min Qty</u></strong>".html_safe }
        column { "<strong><u>Max Qty</u></strong>".html_safe }
        column { "<strong><u>Units / days</u></strong>".html_safe }
        column {"<strong><u>Quantity Ordered</u></strong>".html_safe }
      end
      product.quantity_levels.includes(:user_level).each do |ql|
        columns do
          column {|c| ql.user_level.level}
          column {|c| ql.min_quantity}
          column {|c| ql.max_quantity}
          column {|c| "#{ql.quantity_per_user} / #{ql.duration_per_user}"}
          column {|c| 
            prod_count = ql.user_level.product_order_count(product)
            link_to(prod_count, admin_orders_path('q[by_product_in]': product.id, 'q[user_level_id_eq]': ql.user_level_id))
          }
        end
      end
      ""
    end
    actions
  end
  
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :published
      f.input :quantity_available
      f.input :description
      f.input :image, :as => :file
      f.inputs do
        f.has_many :quantity_levels, allow_destroy: false, new_record: false do |a|
          level_name = "Quatity level for User level: #{UserLevel.where(id: a.object.user_level_id).first.try(:level)}"
          inputs level_name do
            a.input :min_quantity
            a.input :max_quantity
            a.input :quantity_per_user, wrapper_html: { :class => 'fl' }
            a.input :duration_per_user, label: "Duration (in days)", wrapper_html: { :class => 'fl' }
            a.input :user_level_id, as: :hidden
          end
        end
      end
    end
    f.submit f.object.new_record? ? "Create Resource" : "Update"
  end
  

end
