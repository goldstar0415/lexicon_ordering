ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do


    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      
      column do
        panel "User level - Orders" do
          table_for UserLevel.all do
            column("Level")   {|l| l.level }
            column("Orders Placed"){|l| link_to(l.orders.count, admin_orders_path('q[user_level_id_eq]': l.id)) }
          end
        end
      end
      
      column do
        panel "Orders: Waiting Approval" do
          table_for Order.waiting_approval.includes(:order_items, :user).order("id DESC") do
            column("Order#ID")   {|order| link_to("Order##{order.id}", admin_order_path(order)) }
            column("Resources"){|order|  link_to("view", admin_order_order_items_path(order))}
            column("User"){|order|  link_to(order.user.full_name, admin_user_path(order.user))}
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
      end
      
    end  
    
    columns do
      
      column do
        panel "Recent Users" do
          table_for User.order("id DESC").first(5) do
            column("Email")   {|user| link_to(user.email, admin_user_path(user)) }
            column("User Level"){|user| user.level }
            column("Order placed")   {|user| link_to(user.orders.count, admin_orders_path('q[user_id_eq]': user.id)) }
          end          
        end
      end
      
    end

  end # content
end
