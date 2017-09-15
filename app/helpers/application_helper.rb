module ApplicationHelper
  
  def post_order_title(o)
    if o.success?
      "Thank you for your order!"
    elsif o.waiting_approval?
      "Pending for approval"
    end
  end
  
  def support_email
    "support@lexiconresourcesonline.com"
  end
end
