class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects or /projects.json
  def index
    # Shows projects the user owns OR is a member of — .distinct
    # avoids duplicate rows if a project matches both conditions
    @projects = current_user.projects.distinct
  end

  # GET /projects/1 or /projects/1.json
  def show
    # Preload tasks with their assignees in one query (avoids N+1
    # queries when the view loops through tasks and shows each
    # assignee's name)
    @tasks = @project.tasks.includes(:assignee).order(created_at: :desc)
    @new_task = @project.tasks.new # for the "new task" form on the project show page
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = current_user.owned_projects.build(project_params)
    if @project.save
        redirect_to @project, notice: "Project was successfully created."
    else
        render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    if @project.update(project_params)
        redirect_to @project, notice: "Project was successfully updated."
    else
        render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project was successfully destroyed."
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = current_user.projects.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:name, :description)
    end
end
