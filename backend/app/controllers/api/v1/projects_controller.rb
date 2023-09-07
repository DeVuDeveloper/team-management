# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApiController
      before_action :set_project, only: %i[show edit update destroy]

      def index
        @projects = Project.all
        render json: @projects
      end

      def show
        render json: @project
      end

      def new
        render json: @project = Project.new
      end

      def edit
        render json: @project
      end

      def create
        @project = Project.new(project_params)

        respond_to do |format|
          if @project.save
            format.html { redirect_to api_v1_project_url(@project), notice: 'project was successfully created.' }
            format.json { render :show, status: :created, location: @project }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @project.errors, status: :unprocessable_entity }
          end
        end
      end

      def update
        respond_to do |format|
          if @project.update(project_params)
            format.html { redirect_to api_v1_projects_url, notice: 'Project was successfully updated.' }
            format.json { render :show, status: :ok, location: @project }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @project.errors, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        @project.destroy

        respond_to do |format|
          format.html { redirect_to api_v1_projects_url, notice: 'Project was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private

      def set_project
        @project = Project.find_by_id(params[:id])
        render json: { error: 'project not found' }, status: :not_found if @project.nil?
      end

      def project_params
        params.require(:project).permit(:name, :description)
      end
    end
  end
end
