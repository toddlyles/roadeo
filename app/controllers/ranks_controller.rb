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

    @user = current_user
    #@rank = user.rank.new(params[:rank])

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

  def update
    @user = current_user
    
    if params[:direction]=="up" 
      @user.nudge_rank_up(params[:this_idea_id])
    else
    end

    redirect_to :controller=>"ideas",:action=>"show", :id=>params[:return_to_idea_id]

  end

  def destroy
  end


end
