class DatasetsController < ApplicationController
  def index
    @datasets = Api::Dataset.search_by_area_id_and_subject_id(params[:area_id], params[:subject_id])
  end
end
