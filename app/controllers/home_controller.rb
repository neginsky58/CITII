class HomeController < ApplicationController

  def index
    @projects = Project.all
  end

  def new 
    @project = Project.new
  end

  def create
    
  end

end
