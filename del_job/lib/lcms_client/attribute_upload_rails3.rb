require './amenity'
require 'active_record'
require '/scheduled_tasks/passwords'
require 'logger'

ActiveRecord::Base.establish_connection({
    :adapter => 'sqlserver',
    :database => 'expedia_import_tools',
    :username => CHC_IMPORT_TOOLS_USERNAME,
    :password => CHC_IMPORT_TOOLS_PASSWORD,
    :host => 'CHC-SQLMED02'
        })

class HotelAttributeImports < ActiveRecord::Base
end

class AttributeUpdate

  def hotels
    hotels = HotelAttributeImports.find(:all,
                                        :select => "DISTINCT catalog_item_id",
                                        :conditions => " display_rank > 0 and import_type_id = 5",
                                        :order => "catalog_item_id")
  end

  def attributes(catalog_item_id)
    attributes = HotelAttributeImports.find(:all,
                                            :conditions => [" display_rank > 0 AND locked_flag = 'N' and import_type_id = 5 and catalog_item_id = ?", catalog_item_id],
                                            :order => "catalog_item_id, section_type_id, attribute_name")
  end
end

class AttributeUpload
   attr_reader :ui, :rc
   attr_accessor :response 
   def initialize
      @ui = UpdaterInfo.new("SCORE","epc")
      @rc = LCMS::RequestContext.new(1.0, "epc", "epc-000000000000000")
      @amenity = Amenity.new
      @amenity_create = AttributeCreate.new(@ui)
   end
   
   def upload_attribute_for_room(room_id, attribute_id, mode, attribute_value=nil)
     begin
       if File.exists?('lcms.log')
         file = File.open('lcms.log', File::APPEND) 
       else
         file = File.open('lcms.log',File::CREAT)
       end

       logger = Logger.new(file)
       if (mode == 0) || (mode  == 1)
         add_update_attribute_for_room(room_id, attribute_id, attribute_value)
       elsif (mode == 2)
         delete_attribute_for_room(room_id, attribute_id, attribute_value)
       end
     rescue Exception
       logger.error "room_id = #{room_id}|attribute_id = #{attribute_id}|mode = #{mode}|attribute_value = #{attribute_value}" 
     ensure 
       logger.close unless logger.nil?
       #file.close unless file.nil?
     end
   end

   def delete_attribute_for_room(room_id, attribute_id, attribute_value)
      begin
         @rc.request_id = "epc-#{room_id}-#{attribute_id}"
         self.response = @amenity.amenity_get(@rc, attribute_id, room_id)
         if response_contains_errors?
            error_code = response_get_error_code
            if error_code == "1301"
               #Attribute not found in LCMS -- Nothing to delete
               puts "Attribute #{attribute_id} not found in LCMS - Nothing to delete"
            end
         else
            puts "Deleting attribute #{attribute_id} for room #{room_id}"
            self.response = @amenity.amenity_delete(@rc, attribute_id, room_id, @ui)
            handle_errors_in_response
         end
      end
   end

   def add_update_attribute_for_room(room_id, attribute_id, attribute_value=nil)
      begin
         @rc.request_id = "epc-#{room_id}-#{attribute_id}"
         self.response = @amenity.amenity_get(@rc, attribute_id, room_id)
         if response_contains_errors?
            error_code = response_get_error_code
            if error_code == "1301"
               #Attribute not found in LCMS ---create it.
               puts "Attribute #{attribute_id} not found in LCMS for room #{room_id} -- creating"
               self.response = @amenity.amenity_create(@rc, @amenity_create, attribute_id, room_id)
               handle_errors_in_response
            end
         end

         attribute_value = nil if attribute_value.blank?

         if (!attribute_value.nil?) then
            attribute_value_create_update = AttributeValueCreateUpdate.new(attribute_value, @ui)
            #Check if attribute_value is present in LCMS. If yes - update it, otherwise create.
            self.response = @amenity.amenity_value_get(@rc, attribute_id, room_id, 1033)
            if response_contains_data? then
            #Attribute is already present, we need to update
               self.response = @amenity.amenity_value_update(@rc, attribute_id, room_id, attribute_value_create_update, 1033)
               handle_errors_in_response
            else
               error_code = response_get_error_code
               if error_code == "1301"
                  #attribute is not present, we need to create it
                  self.response = @amenity.amenity_value_create(@rc, attribute_id, room_id, attribute_value_create_update, 1033) 
                  handle_errors_in_response
               end
            end
         else
           self.response = @amenity.amenity_value_delete(@rc, attribute_id, room_id, 1033, @ui)
           handle_errors_in_response
           self.response = @amenity.amenity_delete(@rc, attribute_id, room_id, @ui)
           handle_errors_in_response
           self.response = @amenity.amenity_create(@rc, @amenity_create, attribute_id, room_id) 
           handle_errors_in_response
         end
      end
   end

   def upload_attribute_for_hotel(content_owner_id, attribute_id, attribute_value=nil)
      begin
      rescue Exception => e
         puts "There was an exception #{e.message}"
      end
   end

   def log_error(room_id, attribute_id, attribute_value)
      puts "LCMS create/update failed for room[#{room_id}],attribute[#{attribute_id}],append value[#{attribute_value}]"
   end

   def response_contains_data?
      error_code = response_get_error_code
      error_code.nil?
   end

   def response_contains_errors?
      !response_contains_data?
   end

   def response_get_error_list
      response_hash = response.to_hash
      type = response_hash.keys.first
      response_hash[type][:response_context][:error_list]
   end
   
   def response_get_error_code
      error_list = response_get_error_list
      error_list ? error_list[:error][:code] : nil
   end

   def handle_errors_in_response
      if response_contains_errors? then
        raise "LCMS call failed" 
      end
   end
end

#Start


upload = AttributeUpload.new

#First, check if lcms.log exists with errors from prior run of attribute_upload
#If it does, then retry uploading those records.

if File.exists?('lcms.log')
  lcms_logfile = File.open('lcms.log','r')
  retry_attributes = []
  lcms_logfile.each_line do |line|
    line_attributes = line.chop!.split('|')
    retry_attributes << line_attributes
  end
  lcms_logfile.close
  File.delete('lcms.log')
  retry_attributes.each do |attrib|
    cid, attribute_id, mode, attribute_value = attrib
    upload.upload_attribute_for_room(cid, attribute_id, mode, attribute_value)
  end  
end

#Upload attributes from database.

#au = AttributeUpdate.new
#hotels = au.hotels

#hotels.each do |h|
#  cid = h.catalog_item_id
#  attributes = au.attributes(cid)
#  attributes.each do |a|
#    upload.upload_attribute_for_room(cid, a.attribute_id, a.mode, a.attribute_append_txt)
#    a.update_attribute(:locked_flag, 'Y')
#    sleep(1)  #LCMS only supports 1 tps, so sleep for 1 second
#  end
#end
