class RanksController < ApplicationController
  
  #def new
  #end

  #def edit
  #end

  def index
  end

  def show
  end

  def create
    logger.debug "You've arrived at the create action."

    @user = current_user
    
    @user.rank_idea(params[:idea_id], params[:value])
    
    redirect_to :controller=> "ideas", :action=>"show", :id =>params[:idea_id]

    #if @rank.save
     # flash.now[:success] = "Saved."
      #render 'idea/show'
    #else
      #flash.now[:error] = "Errors were found: #{@idea.errors.full_messages.each do |msg| (puts msg) end}" 
      #render 'idea/show'
    #end

  end

  def move
  #custom action for nudging ranks
      @user = current_user
    
    if params[:direction]=="up" 
      @user.nudge_rank_upward(params[:rank_id])
    else
      @user.nudge_rank_downward(params[:rank_id])
    end

    redirect_to :controller=>"ideas",:action=>"show", :id=>params[:return_to_idea_id]
  end


  def update

  end

  def destroy
  end


end
