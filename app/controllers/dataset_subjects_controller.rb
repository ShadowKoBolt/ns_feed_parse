class DatasetSubjectsController < ApplicationController
  def index
    @dataset_subjects = Api::DatasetSubject.find_by_area_id(params[:area_id])
  end
end
