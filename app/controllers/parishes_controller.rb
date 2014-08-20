class ParishesController < ApplicationController

  def search    
    @parishes = Api::Parish.search_by_name(params[:q])
    redirect_to parish_path(@parishes.first.api_code) if @parishes.one? 
  end

  def show
    @parish = Api::Parish.from_area_id(params[:area_id])
    @population_table_data = @parish.get_population
    @population_graph_data = tidy_for_graph(@population_table_data)
  end

  private
    
    def tidy_for_graph(population_graph_data)
      population_graph_data.delete_at(0)
      population_graph_data.collect{|i| [i.first, i.last.to_i] }
    end

end
