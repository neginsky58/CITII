class ProjectsController < ApplicationController
  layout 'home'

  def index
    #@projects = Project.order("created_at desc").page(params[:page]).per_page(5)

    @projects = Project.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html { render layout: 'project'}
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    if current_user == Project.find(params[:id]).user || current_user.try(:admin?)
        @project = Project.find(params[:id])
        @review_comments = @project.review_comments.newest.page(params[:page]).per_page(10)
        @team_members = @project.team_members.page(params[:page]).per_page(20)
        @projectcosts = @project.projectcosts.page(params[:page]).per_page(20)
    else
      redirect_to root_url
    end
  end

  
  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    # @project.category = params[:category][:id]

    respond_to do |format|
      if @project.save
        format.html { redirect_to action: 'index' }

        # if params[:project][:image].blank?
        #   redirect_to @project
        # else
        #   render :action => "crop"
        # end

        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(project_params)
    # @project.category = params[:category][:id]

    respond_to do |format|
      if @project.update_attributes(project_params)
        format.html { redirect_to edit_project_path(@project) }

        # if params[:project][:image].blank?
        #   redirect_to @project
        # else
        #   render :action => "crop"
        # end
        
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    projectuser = Project.find(params[:id]).user
    @project.destroy
    
  end

  private
  def project_params
    params.require(:project).permit(:title, :description, :summary, :picture )
  end 

end
