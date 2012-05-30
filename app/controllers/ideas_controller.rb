class IdeasController < ApplicationController
  
  #GET ACTIONS

  def new
  	@idea = Idea.new
  end

  def edit
  	@idea = Idea.find(params[:id])
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
