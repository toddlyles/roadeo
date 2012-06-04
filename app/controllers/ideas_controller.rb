class IdeasController < ApplicationController
  
  before_filter :authenticate_user!

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
    @ideas = @ideas.sort_by! {|idea| idea.sum_of_ranks}
  end

  def show
  	@idea = Idea.find(params[:id])
  end

  #POST ACTION

  def create
    # the process below results in User ID getting written to the Idea record during creation...yay!
    @user = current_user
  	@idea = @user.ideas.new(params[:idea])

    # set the status of new Ideas to "Active"
    @idea.status = "Active"

  	if @idea.save
      flash.now[:success] = "Saved."
  	  render 'show'
    else
      flash.now[:error] = "Errors were found: #{@idea.errors.full_messages.each do |msg| (puts msg) end}" 
      render 'new'
    end
  end


  #PUT ACTION

  def update
  	@idea = Idea.find(params[:id])
  	if @idea.update_attributes(params[:idea])
      flash.now[:success] ="Saved."
  		render 'show'
  	else
      flash.now[:error] = "Errors were found: #{@idea.errors.full_messages.each do |msg| (puts msg) end}"
  		render 'edit'
  	end
  end

  #DELETE ACTION

  def destroy
  	@Idea.find(params[:id]).destroy
  	redirect_to ideas_path
  end



end
