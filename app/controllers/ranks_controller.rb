class RanksController < ApplicationController
  
  #def new
  #end

  #def edit
  #end

  def index
    @ranks = Rank.all
  end

  def show
  end

  def create
  end

  def destroy
  end
end
