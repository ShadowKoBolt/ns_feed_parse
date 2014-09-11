class ParishesController < ApplicationController
  include NumbersHelper

  def search    
    @parishes = Api::Parish.search_by_name(params[:q])
    redirect_to parish_path(@parishes.first.api_code) if @parishes.one? 
  end

  def show
    @parish = Api::Parish.from_area_id(params[:area_id])
    raw_population_data = @parish.get_population
    @population_table_data = tidy_population_for_table(raw_population_data)
    @population_graph = population_graph(@population_table_data)
    @population_change_table_data = convert_population_to_change(@population_table_data)
    @population_change_graph = population_change_graph(@population_change_table_data)
    raw_dwelling_data = @parish.get_dwellings
    @dwelling_table_data = tidy_dwelling_for_table(raw_dwelling_data)
    @dwelling_graph = dwelling_graph(@dwelling_table_data, @parish.name)
    raw_room_data = @parish.get_rooms
    @room_table_data = tidy_room_for_table(raw_room_data)
    @room_graph = room_graph(@room_table_data, @parish.name)
  end

  private

    def tidy_population_for_table(data)
      ret = []
      ret << data[0]
      ret << ['0-10', data[1..11].collect{|d| d.second.to_i}.sum, data[1..11].collect{|d| d.third.to_i}.sum]
      ret << ['11-20', data[12..21].collect{|d| d.second.to_i}.sum, data[12..21].collect{|d| d.third.to_i}.sum]
      ret << ['21-30', data[22..31].collect{|d| d.second.to_i}.sum, data[22..31].collect{|d| d.third.to_i}.sum]
      ret << ['31-40', data[32..41].collect{|d| d.second.to_i}.sum, data[32..41].collect{|d| d.third.to_i}.sum]
      ret << ['41-50', data[42..51].collect{|d| d.second.to_i}.sum, data[42..51].collect{|d| d.third.to_i}.sum]
      ret << ['51-60', data[52..61].collect{|d| d.second.to_i}.sum, data[52..61].collect{|d| d.third.to_i}.sum]
      ret << ['60+', data[62..-1].collect{|d| d.second.to_i}.sum, data[62..-1].collect{|d| d.third.to_i}.sum]
      ret
    end

    def convert_population_to_change(data)
      ret = []
      data.each do |data_row|
        ret_row = [data_row.first]
        ret_row << percentage_change(data_row.second, data_row.third)
        ret << ret_row
      end
      ret
    end
    
    def population_graph(data)
      data.delete_at(0)
      @chart = LazyHighCharts::HighChart.new('line') do |f|
        f.title(:text => "Population in area by age group")
        f.xAxis(:categories => data.collect(&:first))
        f.series(:name => "2001", :data => data.collect(&:second))
        f.series(:name => "2011", :data => data.collect(&:third))
      end
    end

    def population_change_graph(data)
      @chart = LazyHighCharts::HighChart.new('column') do |f|
        f.title(:text => "Population change in area by age group")
        f.xAxis(:categories => data.collect(&:first))
        f.series(:name => "2001 - 2011 change (%)", :data => data.collect(&:second))
        f.options[:chart][:defaultSeriesType] = "column"
      end
    end

    def tidy_dwelling_for_table(raw_dwelling_data)
      ret = raw_dwelling_data[1..-1]
      ret.pop
      ret = percentages_of_total(ret)
      ret
    end

    def tidy_room_for_table(raw_room_data)
      ret = raw_room_data[0..(raw_room_data.count-2)]
      ret = percentages_of_total(ret)
      ret
    end

    def dwelling_graph(data, name)
      @chart = LazyHighCharts::HighChart.new('column') do |f|
        f.title(:text => "Number of bedrooms in area versus national average")
        f.xAxis(:categories => data.collect{|s| s[0] }, :title => {:text => "Number of Bedrooms"})
        f.yAxis(:title => {:text => 'Percentage of houses with this many bedrooms'}, :min => 0)
        f.series(:name => name, :data => data.collect{|s| s[1] })
        f.series(:name => 'England and Wales', :data => data.collect{|s| s[2] })
        f.options[:chart][:defaultSeriesType] = "column"
      end
    end

    def room_graph(data, name)
      @chart = LazyHighCharts::HighChart.new('column') do |f|
        f.title(:text => "Number of rooms in area versus national average")
        f.xAxis(:categories => data.collect{|s| s[0] }, :title => {:text => "Number of rooms"})
        f.yAxis(:title => {:text => 'Percentage of houses with this many rooms'}, :min => 0)
        f.series(:name => name, :data => data.collect{|s| s[1] })
        f.series(:name => 'England and Wales', :data => data.collect{|s| s[2] })
        f.options[:chart][:defaultSeriesType] = "column"
      end
    end

end
