class OrderMailer < ApplicationMailer
  
  def order_confirmation(order)
    @order = order
    @user = @order.user
    subject = "Order##{order.id} Status:#{order.status}"
    recipients = ::AdminUser.all.collect(&:email)
    recipients << order.user.email
    mail(to: recipients.join(', '), subject: subject)
  end
end
