#Requires Ruby version 1.8.5 or highet
require 'rubygems'
require 'savon'

module LCMS
   DOCUMENT_URL = "http://chellssapptst60.karmalab.net:52450/lcms/services/lodgingcontentmaster.wsdl"
   SERVICE_ENDPOINT = "http://chellssapptst60.karmalab.net:52450/lcms/services"

   class RequestContext
      attr_accessor :request_id
      def initialize(version, user_code, request_id)
         @version = version
         @user_code = user_code
         @request_id = request_id
      end

      def to_s
          "<ins0:Version>#{@version}</ins0:Version><ins0:UserCode>#{@user_code}</ins0:UserCode><ins0:RequestID>#{@request_id}</ins0:RequestID>"
      end
   end

   class LCMSBase
      def initialize
         #disable Savon logging
         Savon.configure do |config|
           config.log = false
         end
         
         #disable HTTPI logging
         HTTPI.log = false

         @client = Savon::Client.new do
            wsdl.document = DOCUMENT_URL
            wsdl.endpoint = SERVICE_ENDPOINT   
         end
      end
   end
end

