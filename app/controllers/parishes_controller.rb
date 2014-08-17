class ParishesController < ApplicationController
  def search    
    @parishes = Api::Parish.search_by_name(params[:q])
  end

  def show
    @datasets = Api::Dataset.search_by_area_id(params[:area_id])
  end

end
