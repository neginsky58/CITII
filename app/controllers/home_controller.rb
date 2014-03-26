class HomeController < ApplicationController

  def index
    @project = Project.new
  end

  def new 
    @project = Project.new
  end

  def create
    
  end

end
