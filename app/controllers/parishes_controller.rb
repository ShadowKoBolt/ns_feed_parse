class ParishesController < ApplicationController
  def search    
    @parishes = Api::Parish.search_by_name(params[:q])
  end

  def show
    @parish = Api::Parish.from_area_id(params[:area_id])
    @population = @parish.get_population
  end

end
