class StaticPagesController < ApplicationController
  def home
  end

  def dashboard
  end


  def admin
  	if current_user.role_id !=3
  		flash.now[:error] = "You must be an Administrator."
  		render 'home'
  	end
  end


end
