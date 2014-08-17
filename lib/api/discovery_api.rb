module Api
  class DiscoveryApi
    def self.client
      Savon.client do
        wsdl 'https://www.neighbourhood.statistics.gov.uk/NDE2/Disco?wsdl'
        convert_request_keys_to :camelcase
        ssl_version :TLSv1
        namespaces 'xmlns:ns2' => 'http://neighbourhood.statistics.gov.uk/nde/v1-0/discoverystructs'
      end
    end
  end
end
