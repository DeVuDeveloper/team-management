class Api::V1::Android::ProjectsController < ApiController
  include ApplicationHelper
  before_action :set_project, only: %i[show]
  before_action :is_admin?

  def index
    @projects = Project.all
    render json: @projects
  end

  def show
    render json: @project
  end

  private

  def set_project
    @project = Project..find(params[:id])
  end

  def project_params
    params.require(:project)
  end
end
