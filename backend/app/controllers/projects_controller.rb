# frozen_string_literal: true

class ProjectsController < ApplicationController
  include ApplicationHelper
  before_action :set_project, only: %i[show edit update destroy]
  before_action :authenticate_user!
  before_action :is_admin?

  def index
    @projects = Project.all
  end

  def show; end

  def new
    @project = Project.new
  end

  def edit; end

  def create
    @project = Project.new(projects_params)

    respond_to do |format|
      if @project.save!
        format.html { redirect_to projects_url(@projects), notice: 'projects was successfully created.' }
        format.json { render :show, status: :created, location: @projects }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @projects.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @projects.update(projects_params)
        format.html { redirect_to projects_url(@projects), notice: 'projects was successfully updated.' }
        format.json { render :show, status: :ok, location: @projects }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @projects.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'projects was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def projects_params
    params.require(:project).permit(:name, :description)
  end
end
