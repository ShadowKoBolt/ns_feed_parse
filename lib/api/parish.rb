module Api
  class Parish

    PopulationTableId = 91

    attr_accessor :name, :descriptor, :api_code, :ext_code
    def self.search_by_name(query)
      response = Api::DiscoveryApi.client.call(:search_area_by_name_hierarchy) do
        message 'ns2:HierarchyId' => 29, 'ns2:AreaNamePart' => query
      end
      return [] if response.body[:search_area_by_name_hierarchy_response_element][:area_falls_withins].nil?
      area_falls_withins = response.body[:search_area_by_name_hierarchy_response_element][:area_falls_withins][:area_falls_within]
      parishes = []
      if area_falls_withins.is_a?(Array)
        area_falls_withins.each do |area_falls_within|
          parishes << Api::Parish.from_search_area_by_name_hierarchy_response_element(area_falls_within)
        end
      elsif area_falls_withins.is_a?(Hash)
        parishes << Api::Parish.from_search_area_by_name_hierarchy_response_element(area_falls_withins)
      end
      parishes
    end

    def self.from_search_area_by_name_hierarchy_response_element(json)
      parish = Api::Parish.new
      parish.name = json[:area][:name]
      parish.descriptor = json[:falls_within][:area][:name] if json[:falls_within]
      parish.api_code = json[:area][:area_id]
      parish
    end

    def self.from_area_id(area_id)
      response = Api::DiscoveryApi.client.call(:get_area_detail) do
        message 'ns2:AreaId' => area_id.to_i
      end
      area_detail = response.body[:get_area_detail_response_element][:area_detail]
      parish = Api::Parish.new
      parish.name = area_detail[:name]
      parish.api_code = area_id
      parish.ext_code = area_detail[:ext_code]
      parish
    end

    def get_population
      api_code = self.api_code
      response = Api::DeliveryApi.client.call(:get_tables) do
        message 'Areas' => api_code, 'Datasets' => PopulationTableId
      end
      topics = response.body[:get_data_cube_response_element][:datasets][:dataset][:topics][:topic]
      binding.pry
    end

  end
end
