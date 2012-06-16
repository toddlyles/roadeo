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
    
    redirect_to :back

  end

  def move
  #custom action for nudging ranks
      @user = current_user
    
    if params[:direction]=="up" 
      @user.nudge_rank_upward(params[:rank_id])
    else
      @user.nudge_rank_downward(params[:rank_id])
    end

    redirect_to :back
  end


  def update

  end

  def destroy

    @rank = Rank.find_by_id(params[:rank_id])

    @rank.destroy

    #redirect_to :controller=>"ideas",:action=>"show", :id=>params[:return_to_idea_id]

    redirect_to :back

  end


end
