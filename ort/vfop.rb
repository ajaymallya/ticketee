require 'savon'

module VFOP
  DOCUMENT_URL = "http://paymentoption.karmalab.net/PaymentOptions/v2?wsdl"
  SERVICE_ENDPOINT = "http://paymentoption.karmalab.net:80/PaymentOptions/v2"

  class VFOPBase
    def initialize
      Savon.configure do |config|
        #config.log = false
      end
      Savon.env_namespace = :S
      #HTTPI.log = false
      @client = Savon::Client.new do |wsdl,http,wsse| 
        wsdl.document = DOCUMENT_URL
        wsdl.endpoint = SERVICE_ENDPOINT
        http.auth.ssl.verify_mode = :none
        wsse.credentials 'd8495271-9b91-446c-a719-b5d551514b52',''
      end
    end
  end

  class VFOP < VFOPBase
    def get_payment_options_by_sle_country_and_currency(request_info, sle_country_code, currency_code)
      response = @client.request "urn:GetPaymentOptionsBySLECountryAndCurrencyRQ" do
        soap.namespaces["xmlns:urn"] = "urn:expedia:payment:options:messages:v2"
        soap.namespaces["xmlns:urn1"] = "urn:expedia:payment:system:types:v2"
        soap.namespaces["xmlns:S"] = "http://www.w3.org/2003/05/soap-envelope"
        soap.body = {
          "urn1:RequestInfo" => request_info,
          "urn:SLECountryCode" => sle_country_code,
          "urn:CurrencyCode" => currency_code,
          :order! => ["urn1:RequestInfo", "urn:SLECountryCode", "urn:CurrencyCode"]
        }
      end
    end
  end

  class RequestInfo
    def initialize(requestor_id, request_id)
      @requestor_id = requestor_id
      @request_id = request_id
    end
    def to_s
      "<urn1:RequestorID>#{@requestor_id}</urn1:RequestorID><urn1:RequestID>#{@request_id}</urn1:RequestID>"
    end
  end
end


#ri = VFOP::RequestInfo.new('test','d989f698-fbd2-4310-889c-ae1d5d0cfac7')


