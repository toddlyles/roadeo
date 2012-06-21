class StaticPagesController < ApplicationController
  

  def home
  	if user_signed_in?
  		redirect_to dashboard_path
  	end
  end

 


  def admin
  	if current_user.role_id !=3
  		flash.now[:error] = "You must be an Administrator."
  		render 'home'
  	end
  end


end
