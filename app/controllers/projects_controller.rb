class ProjectsController < ApplicationController
  def admin
    if current_user.try(:admin?)
      @projects = Project.submittedforapproval.pendingapproval.page(params[:pendingapproval_page]).per_page(25)
      @activeprojects = Project.approved.page(params[:activeprojects_page]).per_page(25)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @projects }
      end
    else
      redirect_to root_url
    end
  end

  def index
    #@projects = Project.order("created_at desc").page(params[:page]).per_page(5)

    @projects = Project.approved.newest.page(params[:page]).per_page(5)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    if Project.find(params[:id]).projectreviewed == true || current_user.try(:admin?) || current_user == Project.find(params[:id]).user
      @project = Project.find(params[:id])
      @commentable = @project
      @newcomments = @commentable.newcomments.newest.page(params[:comments_page]).per_page(5)
      @newcomment = Newcomment.new
      @blogupdates = @project.blogupdates.newest.page(params[:blogupdates_page]).per_page(5)
      @review_comments = @project.review_comments.newest.page(params[:page]).per_page(10)
      @team_members = @project.team_members.page(params[:page]).per_page(10)
      
      
      # Written by Frank
      @sum_of_funded = Donates.sum(:amount, :conditions => ['project_id = ?', params[:id]])
      @count_of_donated = Donates.count(:donator_id, :distinct => true, :conditions => ['project_id = ?', params[:id]])      
      
      @donator_ids = Donates.find(:all, :group => :donator_id, :select=> :donator_id, :conditions => ['project_id = ?', params[:id]])
      ids = Array.new
      @donator_ids.each do |donator|
        ids.push(donator[:donator_id])   
      end
       
      @donators = User.find(ids)
      
      
    else
      redirect_to root_url
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = current_user.projects.new

    respond_to do |format|
      format.html # new.html.erb
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

  def editteam
    if current_user == Project.find(params[:id]).user
        @project = Project.find(params[:id])
        @review_comments = @project.review_comments.newest.page(params[:page]).per_page(10)
        @team_members = @project.team_members.page(params[:page]).per_page(20)
    else
      redirect_to root_url
    end
  end

  def editprojectcosts
    if current_user == Project.find(params[:id]).user
        @project = Project.find(params[:id])
        @projectcosts = @project.projectcosts.organizedbyname.page(params[:projectcosts_page]).per_page(20)
    else
      redirect_to root_url
    end
  end

  def editcomments
    if current_user == Project.find(params[:id]).user
        @project = Project.find(params[:id])
        @review_comments = @project.review_comments.newest.page(params[:page]).per_page(10)
        @team_members = @project.team_members.page(params[:page]).per_page(20)
    else
      redirect_to root_url
    end
  end

  def comments
    @project = Project.find(params[:id])
    @commentable = @project
    @newcomments = @commentable.newcomments.newest.page(params[:comments_page]).per_page(10)
    @newcomment = Newcomment.new
    @team_members = @project.team_members.page(params[:page]).per_page(10)
    # @ttwocomments = @commentable.newcomment.ttwocomments.newest.page(params[:ttwocomments_page]).per_page(2)


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project.comments }
    end
  end

  def blogs
    @project = Project.find(params[:id])
    @blogupdates = @project.blogupdates.newest.page(params[:blogupdates_page]).per_page(5)
    @team_members = @project.team_members.page(params[:page]).per_page(10)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project.blogs }
    end
  end

  def team
    @project = Project.find(params[:id])
    @team_members = @project.team_members

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def finances
    @project = Project.find(params[:id])
    @projectcosts = @project.projectcosts.organizedbyname.page(params[:projectfinances_page]).per_page(10)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.new(params[:project])
    # @project.category = params[:category][:id]

    respond_to do |format|
      if @project.save
        format.html { redirect_to edit_project_path(@project), notice: 'Project was successfully started.' }

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
    @project = Project.find(params[:id])
    # @project.category = params[:category][:id]

    respond_to do |format|
      if @project.update_attributes(params[:project])
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

  def submitreview
    @project = Project.find(params[:id])
    @project.update_attributes(submitreview: true)
    redirect_to project_path(@project)
  end

  def returntouser
    @project = Project.find(params[:id])
    @project.update_attributes(submitreview: false)
    redirect_to admin_url
  end

  def projectapproved
    @project = Project.find(params[:id])
    @project.update_attributes(projectreviewed: true)
    redirect_to admin_url
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    projectuser = Project.find(params[:id]).user
    @project.destroy

    if current_user == projectuser
      respond_to do |format|
        format.html { redirect_to pendingprojects_user_path(current_user) }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_url }
        format.json { head :no_content }
      end
    end
  end

  def following
    @title = "Followers"
    @project = Project.find(params[:id])
    @users = @project.favorited_by.newest.page(params[:followers_page]).per_page(5)
    @team_members = @project.team_members.page(params[:page]).per_page(10)
    render 'show_follow'
  end

end
