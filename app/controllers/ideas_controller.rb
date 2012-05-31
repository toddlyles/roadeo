class IdeasController < ApplicationController
  
  before_filter :authenticate_user!

  #GET ACTIONS

  def new
    if user_signed_in?
  	 @idea = Idea.new
    else
      render 'devise/registrations/new'
    end 
  end

  def edit
    if user_signed_in?
  	 @idea = Idea.find(params[:id])
    else
      render 'devise/registrations/new'
    end
  end

  def index
  	#@ideas = Idea.paginate(page:params[:range])
  	@ideas = Idea.all
  end

  def show
  	@idea = Idea.find(params[:id])
  end

  #POST ACTION

  def create
  	@idea = Idea.new(params[:idea])
  	@idea.save
  	render 'show'
  end

  #PUT ACTION

  def update
  	@idea = Idea.find(params[:id])
  	if @idea.update_attributes(params[:idea])
  		render 'show'
  	else
  		render 'edit'
  	end
  end

  #DELETE ACTION

  def destroy
  	@Idea.find(params[:id]).destroy
  	redirect_to ideas_path
  end

end
