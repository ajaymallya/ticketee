$: << File.dirname(__FILE__)
require 'lcms'

class PropertyContentCreateUpdate
   def initialize(updater_info)
      @updater_info = updater_info
   end
   def to_s 
      "<ins0:UpdaterInfo>#{@updater_info}</ins0:UpdaterInfo>"
   end
end

class PropertyContentDeleteFiltersType
   def initialize(sections, section_groups, exclude_room_type=false,exclude_rate_plan=false, exclude_property=false) 
      @sections = sections
      @section_groups = section_groups
      @exclude_room_type = exclude_room_type
      @exclude_rate_plan = exclude_rate_plan
      @exclude_property = exclude_property
   end
   def to_s 
      "<ins0:Sections>#{@sections}</ins0:Sections><ins0:SectionGroups>#{@section_groups}</ins0:SectionGroups><ins0:ExcludeRoomType>#{@exclude_room_type}</ins0:ExcludeRoomType><ins0:ExcludeRatePlan>#{@exclude_rate_plan}</ins0:ExcludeRatePlan><ins0:ExcludeProperty>#{@exclude_property}</ins0:ExcludeProperty>"
   end
end

class NameCreateUpdate
   def initialize(value, updater_info)
      @name = name
      @updater_info = updater_info
   end
   def to_s
      "<ins0:Name>#{@name}</ins0:Name><ins0:UpdaterInfo>#{@updater_info}</ins0:UpdaterInfo>"
   end
end

class RatingCreateUpdate
   def initialize(value, updater_info)
      @value = value
      @updater_info = updater_info
   end
   def to_s
      "<ins0:Value>#{@value}</ins0:Value><ins0:UpdaterInfo>#{@updater_info}</ins0:UpdaterInfo>"
   end
end


class Property < LCMSBase
      
   def property_content_create(request_context, property_content_create, property_shell_id)
      response = @client.request "PropertyContentCreateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContent" => property_content_create,
            :attributes! => {"ins0:PropertyContent" => {"propertyShellID" => property_shell_id}}
         }
      end
   end

# This can be batched
   def property_content_update(request_context, property_content_update, property_content_id, property_shell_id)
      response = @client.request "PropertyContentUpdateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContent" => property_content_update,
            :attributes! => {"ins0:PropertyContent" => {"id" => property_content_id, "propertyShellID" => property_shell_id}}
         }
      end
   end

   def property_content_get(request_context, property_content_id)
      response = @client.request "PropertyContentGetRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id
         }
      end
   end
      
   def property_content_delete(request_context, property_content_id, updater_info)
      response = @client.request "PropertyContentDeleteRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:UpdaterInfo" => updater_info
         }
      end
   end

   def property_content_aggregate_delete(request_context, property_content_id, filters, updater_info)
      response = @client.request "PropertyContentAggregateDeleteRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:Filters" => filters,
            "ins0:UpdaterInfo" => updater_info
         }
      end
      response
   end

   def property_name_create(request_context, property_content_id, name_create, language)
      response = @client.request "NameCreateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:Name" => name_create,
            :attributes! => {"ins0:Name" => {"language" => language}}
         }
      end
      response
   end

   def property_name_get(request_context, property_content_id, language)
      response = @client.request "NameGetRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:Language" => language
         }
      end
      response
   end

   def property_name_update(request_context, property_content_id, name_update, language)
      response = @client.request "NameUpdateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:Name" => name_update,
            :attributes! => {"ins0:Name" => {"language" => language}}
         }
      end
      response
   end

   def property_name_delete(request_context, property_content_id, language, updater_info)
      response = @client.request "NameDeleteRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:Language" => language,
            "ins0:UpdaterInfo" => updater_info
         }
      end
      response
   end

   def rating_create(request_context, property_content_id, rating_create, rating_id)
      response = @client.request "RatingCreateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:Rating" => rating_create,
            :attributes! => {"ins0:Rating" => {"id" => rating_id}}
         }
      end
      response
   end

   def rating_get(request_context, property_content_id, rating_id)
      response = @client.request "RatingGetRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:RatingID" => rating_id
         }
      end
      response
   end

   def rating_update(request_context, property_content_id, rating_update, rating_id)
      response = @client.request "RatingUpdateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:Rating" => rating_update,
            :attributes => {"ins0:Rating" => {"id" => rating_id}}
         }
      end
      response
   end

   def rating_delete(request_context, property_content_id, rating_id, updater_info)
      response = @client.request "RatingDeleteRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:RatingID" => rating_id,
            "ins0:UpdaterInfo" => updater_info
         }
      end
      response
   end

   def tagline_create(request_context, property_content_id, tagline_create, language)
      response = @client.request "TaglineCreateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:Tagline" => tagline_create,
            :attributes! => {"ins0:Tagline" => {"language" => language}}
         }
      end
      response
   end

   def tagline_get(request_context, property_content_id, language)
      response = @client.request "TaglineGetRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:Language" => language
         }
      end
      response
   end

   def tagline_update(request_context, property_content_id, tagline_update, language)
      response = @client.request "TaglineUpdateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:Tagline" => tagline_update,
            :attributes => {"ins0:Tagline" => {"language" => language}}
         }
      end
      response
   end

   def rating_delete(request_context, property_content_id, language, updater_info)
      response = @client.request "TaglineDeleteRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:PropertyContentID" => property_content_id,
            "ins0:Language" => language,
            "ins0:UpdaterInfo" => updater_info
         }
      end
      response
   end

end
