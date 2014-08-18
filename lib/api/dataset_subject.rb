module Api
  class DatasetSubject

    attr_accessor :name, :api_code, :count
    def self.find_by_area_id(area_id)
      response = Api::DiscoveryApi.client.call(:get_compatible_subjects) do
        message 'ns2:AreaId' => area_id
      end
      subjects_with_count = response.body[:get_compatible_subjects_response_element][:subjects_with_count][:subject_with_count]
      dataset_subjects = []
      if subjects_with_count.is_a?(Array)
        subjects_with_count.each do |subject_with_count|
          dataset_subjects << Api::DatasetSubject.from_subject_with_count(subject_with_count)
        end
      elsif subjects_with_count.is_a?(Hash)
        dataset_subjects << Api::DatasetSubject.from_subject_with_count(subject_with_count)
      end
      dataset_subjects
    end

    def self.from_subject_with_count(json)
      dataset_subject = Api::DatasetSubject.new
      dataset_subject.name = json[:subject][:name]
      dataset_subject.count = json[:count]
      dataset_subject.api_code = json[:subject][:subject_id]
      dataset_subject
    end

  end
end
