class ChangePasswordController < ApplicationController
  
  before_action :authenticate_user!
  
  def new
	  
	  create
	  
  end

	def create
		#current_password = params[:change_password][:password]
		
    #hashed_password = BCrypt::Password.create(current_password)
		
		
		
    @user = current_user
    if @user #&& BCrypt::Password.new(@user.password) == params[:change_password][:password]
      @user.create_reset_digest
      redirect_to edit_password_reset_url(@user.reset_token, email: @user.email)
    else
      flash.now[:danger] = "Invalid Current Password"
      render 'new'
    end
  end

  def edit
  end
  
end
