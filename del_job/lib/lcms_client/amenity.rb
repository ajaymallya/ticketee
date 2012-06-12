$: << File.dirname(__FILE__)
require 'lcms'

class UpdaterInfo
   def initialize(location, user)
      @location = location
      @user = user
   end
   def to_s 
      "<ins0:Location>#{@location}</ins0:Location><ins0:User>#{@user}</ins0:User>"
   end
end

class AttributeCreate
   def initialize(updater_info)
      @updater_info = updater_info
   end
  
   def to_s
      "<ins0:UpdaterInfo>#{@updater_info}</ins0:UpdaterInfo>"
   end
end

class AttributeValueCreateUpdate
   def initialize(text, updater_info)
      @text = text
      @updater_info = updater_info
   end
   def to_s
      "<ins0:Text>#{@text}</ins0:Text><ins0:UpdaterInfo>#{@updater_info}</ins0:UpdaterInfo>"
   end
end

class Amenity < LCMS::LCMSBase
   def amenity_get(request_context, attribute_type, content_owner_id)
      response = @client.request "AttributeGetRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:AttributeType" => attribute_type,
            "ins0:ContentOwnerID" => content_owner_id,
            :order! => ["ins0:RequestContext","ins0:AttributeType","ins0:ContentOwnerID"]
         }
      end
   end

   def amenity_value_get(request_context, attribute_type, content_owner_id, language)
      response = @client.request "AttributeValueGetRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:AttributeType" => attribute_type,
            "ins0:ContentOwnerID" => content_owner_id,
            "ins0:Language" => language,
            :order! => ["ins0:RequestContext","ins0:AttributeType","ins0:ContentOwnerID","ins0:Language"]
         }
      end
      response
   end

   def amenity_value_create(request_context, amenity_type, content_owner_id, attribute_value, language)
      response = @client.request "AttributeValueCreateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:AttributeType" => amenity_type,
            "ins0:ContentOwnerID" => content_owner_id,
            "ins0:AttributeValue" => attribute_value,
             :attributes! => {"ins0:AttributeValue" => {"language" => language}},
             :order! => ["ins0:RequestContext","ins0:AttributeType","ins0:ContentOwnerID","ins0:AttributeValue"]
         }
      end
      response
   end

   def amenity_value_update(request_context, amenity_type, content_owner_id, attribute_value, language)
      response = @client.request "AttributeValueUpdateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:AttributeType" => amenity_type,
            "ins0:ContentOwnerID" => content_owner_id,
            "ins0:AttributeValue" => attribute_value,
            :attributes! => {"ins0:AttributeValue" => {"language" => language}}, 
            :order! => ["ins0:RequestContext","ins0:AttributeType","ins0:ContentOwnerID", "ins0:AttributeValue"]
         }
      end
      response
   end

   def amenity_value_delete(request_context, amenity_type, content_owner_id, language, updater_info)
      response = @client.request "AttributeValueDeleteRQ" do 
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:AttributeType" => amenity_type,
            "ins0:ContentOwnerID" => content_owner_id,
            "ins0:Language" => language,
            "ins0:UpdaterInfo" => updater_info,
            :order! => ["ins0:RequestContext", "ins0:AttributeType", "ins0:ContentOwnerID","ins0:Language","ins0:UpdaterInfo"]
          }
      end
      response
   end

   def amenity_create(request_context, attribute_create, attribute_type, content_owner_id)
      response = @client.request "AttributeCreateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:Attribute" => attribute_create,
             :attributes! => {"ins0:Attribute" => {"type" => attribute_type, "contentOwnerID" => content_owner_id}},
             :order! => ["ins0:RequestContext","ins0:Attribute"]
         }
      end
      response
   end
 
   def amenity_delete(request_context, amenity_type, content_owner_id, updater_info)
      response = @client.request "AttributeDeleteRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:AttributeType" => amenity_type,
            "ins0:ContentOwnerID" => content_owner_id,
            "ins0:UpdaterInfo" => updater_info, 
            :order! => ["ins0:RequestContext","ins0:AttributeType","ins0:ContentOwnerID","ins0:UpdaterInfo"]
         }
      end
      response
   end 
end

ui = UpdaterInfo.new("SCORE","a-amallya")
ac = AttributeCreate.new(ui)
rc = LCMS::RequestContext.new(1.0,"epc","4599626---fbe7d5d1-e107-4811-8863-605eb654e277")

#amenity = Amenity.new
#amenity.attribute_create(rc, ac)
