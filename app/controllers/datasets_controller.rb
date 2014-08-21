class DatasetsController < ApplicationController
  def index
    @datasets = Api::Dataset.search_by_area_id_and_subject_id(params[:area_id], params[:subject_id])
  end

  def show
    @parish = Api::Parish.from_area_id(params[:area_id])
    render json: @parish.get_dataset_json(params[:dataset_id])
  end
end
