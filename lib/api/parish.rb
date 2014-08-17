module Api
  class Parish

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

  end
end
