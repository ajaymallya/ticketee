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

class RoomTypeContentCreate
   def initialize(name, updater_info)
      @name = name
      @updater_info = updater_info
   end
   def to_s
      "<ins0:Name>#{@name}</ins0:Name><ins0:UpdaterInfo>#{@updater_info}</ins0:UpdaterInfo>"
   end
end

class RoomTypeName
   def initialize(value, updater_info)
      @value = value
      @updater_info = updater_info
   end
   def to_s
      "<ins0:Value>#{@value}</ins0:Value><ins0:UpdaterInfo>#{@updater_info}</ins0:UpdaterInfo>"
   end
end

class RoomType < LCMS::LCMSBase
   def room_type_create(request_context, room_type_content, room_type_id, property_shell_id)
      response = @client.request "RoomTypeCreateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:RoomTypeContent" => room_type_content,
            :attributes! => {"ins0:RoomTypeContent" => {"roomTypeID" => room_type_id, "propertyShellID" => property_shell_id}}
         }
      end
      response
   end

   def room_type_get(request_context, room_type_content_id)
      response = @client.request "RoomTypeGetRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:RoomTypeContentID" => room_type_content_id
         }
      end
      response
   end

   def room_type_delete(request_context, room_type_content_id, updater_info)
      response = @client.request "RoomTypeDeleteRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:RoomTypeContentID" => room_type_content_id,
            "ins0:UpdaterInfo" => updater_info
         }
      end
      response
   end

   def room_type_name_create(request_context, room_type_content_id, name_create, language)
      response = @client.request "RoomTypeNameCreateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:RoomTypeContentID" => room_type_content_id,
            "ins0:Name" => name_create,
            :attributes! => {"ins0:Name" => {"language" => language}} 
         }
      end
      response
   end

   def room_type_name_get(request_context, room_type_content_id, language)
      response = @client.request "RoomTypeNameGetRQ" do 
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:RoomTypeContentID" => room_type_content_id,
            "ins0:Language" => language
          }
      end
      response
   end

   def room_type_name_delete(request_context, room_type_content_id, language, updater_info)
      response = @client.request "RoomTypeNameDeleteRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:RoomTypeContentID" => room_type_content_id,
            "ins0:Language" => language,
            "ins0:UpdaterInfo" => updater_info
         }
      end
      response
   end
 
   def room_type_name_update(request_context, room_type_content_id, name_update, language)
      response = @client.request "RoomTypeNameUpdateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:RoomTypeContentID" => room_type_content_id,
            "ins0:Name" => name_update,
            :attributes! => {"ins0:Name" => {"language" => language}}
         }
      end
      response
   end 
end
