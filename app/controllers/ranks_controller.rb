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

  def move
  #custom action for nudging ranks
      @user = current_user
    
    #if params[:direction]=="up" 
      #@user.nudge_rank_up(params[:id])
    
    @your_current_rankings = @user.get_rankings
    @switch_places = false
    @counter = 0
    
    #flash.now[:error]="#{@your_current_rankings.count}"
    @your_current_rankings.each do |rank|
      #flash.now[:error] = "Entered Loop: #{params[:this_idea_id]}"
      
      @counter+=1

      if rank.idea_id == params[:this_idea_id]
       flash.now[:error] = "Found it!"
        #you've found it in the array--now is the slot above it occupied?
        @your_current_rankings.each do |other_rank|
          if rank.value-1 == other_rank.value
            #uh-oh...the next rank is occupied...need to switch places
            @switch_places = true
            @unlucky_rank = other_rank
          end
        end

        #elevate the rank
        if rank.value != 1
          rank.value -= 1
        end

        #lower the poor bastard above it
        if @switch_places
          @unlucky_rank.value +=1
        end

        #save your work
        #rank.transaction do
          rank.save
          flash.now[:success] ="Saved."
          if @switch_places
            if @go_ahead_and_delete_it
              @unlucky_rank.delete
            else
              @unlucky_rank.save
            end
          end
        #end
      end

    end

    flash.now[:error]="#{@counter}"

    #else
    #end
    #redirect_to :controller=>"ideas",:action=>"show", :id=>params[:return_to_idea_id]
  end


  def update

  end

  def destroy
  end


end
