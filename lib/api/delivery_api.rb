class Api::DeliveryApi
  def self.client
    Savon.client do
      wsdl 'https://www.neighbourhood.statistics.gov.uk/NDE2/Deli?wsdl'
      convert_request_keys_to :camelcase
      ssl_version :TLSv1
    end
  end
end
