module Api
  class Dataset

    attr_accessor :name, :api_code
    def self.search_by_area_id_and_subject_id(area_id, subject_id)
      response = Api::DiscoveryApi.client.call(:get_datasets) do
        message 'ns2:SubjectId' => subject_id, 'ns2:Areaid' => area_id
      end
      get_datasets_response_element = response.body[:get_datasets_response_element]
      return [] if get_datasets_response_element[:ds_families].nil?
      ds_famlies = get_datasets_response_element[:ds_families][:ds_family]
      datasets = []
      if ds_famlies.is_a?(Array)
        ds_famlies.each do |ds_family|
          datasets << Api::Dataset.from_ds_family(ds_family)
        end
      elsif ds_families.is_a?(Hash)
        datasets << Api::Dataset.from_ds_family(ds_families)
      end
      datasets
    end

    def self.from_ds_family(json)
      dataset = Api::Dataset.new
      dataset.name = json[:name]
      dataset.api_code = json[:ds_family_id]
      dataset
    end

  end
end
