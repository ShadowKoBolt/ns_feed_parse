class ParishesController < ApplicationController

  def search    
    @parishes = Api::Parish.search_by_name(params[:q])
    redirect_to parish_path(@parishes.first.api_code) if @parishes.one? 
  end

  def show
    @parish = Api::Parish.from_area_id(params[:area_id])
    raw_population_data = @parish.get_population
    @population_table_data = tidy_population_for_table(raw_population_data)
    @population_graph_data = tidy_population_for_graph(@population_table_data)
  end

  private

    def tidy_population_for_table(raw_population_data)
      ret = []
      ret << raw_population_data[0]
      ret << ['0-10', raw_population_data[1..11].collect{|d| d.last.to_i}.sum]
      ret << ['10-20', raw_population_data[12..21].collect{|d| d.last.to_i}.sum]
      ret << ['20-30', raw_population_data[22..31].collect{|d| d.last.to_i}.sum]
      ret << ['30-40', raw_population_data[32..41].collect{|d| d.last.to_i}.sum]
      ret << ['40-50', raw_population_data[42..51].collect{|d| d.last.to_i}.sum]
      ret << ['50-60', raw_population_data[52..61].collect{|d| d.last.to_i}.sum]
      ret << ['60+', raw_population_data[61..-1].collect{|d| d.last.to_i}.sum]
      ret
    end
    
    def tidy_population_for_graph(raw_population_data)
      raw_population_data.delete_at(0)
      raw_population_data
    end

end
