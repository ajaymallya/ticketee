require './amenity'
require 'active_record'
require '/scheduled_tasks/passwords'

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
                                            :conditions => [" display_rank > 0 AND locked_flag = 'N' and import_type_id = 3 and catalog_item_id = ?", catalog_item_id],
                                            :order => "catalog_item_id, section_id, attribute_name")
  end
end

class AttributeUpload
   attr_reader :ui, :rc
   attr_accessor :response 
   def initialize
      @ui = UpdaterInfo.new("SCORE","epc")
      @rc = LCMS::RequestContext.new(1.0, "epc", "4599626---fbe7d5d1-e107-4811-8863-605eb654e277")
      @amenity = Amenity.new
      @amenity_create = AttributeCreate.new(@ui)
   end

   def upload_attribute_for_hotel(hotel_id, attribute_id, attribute_value=nil)
      begin
         self.response = @amenity.amenity_get(@rc, attribute_id, hotel_id)
         if response_contains_errors?
            error_code = response_get_error_code
            if error_code == "1301"
               #Attribute not found in LCMS ---create it.
               puts "Attribute #{attribute_id} not found in LCMS for hotel #{hotel_id} -- creating"
               self.response = @amenity.amenity_create(@rc, @amenity_create, attribute_id, hotel_id)
               handle_errors_in_response
            end
         end
   
         if (!attribute_value.nil?) then
            attribute_value_create_update = AttributeValueCreateUpdate.new(attribute_value, @ui)
            #Check if attribute_value is present in LCMS. If yes - update it, otherwise create.
            self.response = @amenity.amenity_value_get(@rc, attribute_id, hotel_id, 1033)
            if response_contains_data? then
            #Attribute is already present, we need to update
               self.response = @amenity.amenity_value_update(@rc, attribute_id, hotel_id, attribute_value_create_update, 1033)
               handle_errors_in_response
            else
               error_code = response_get_error_code
               if error_code == "1301"
                  #attribute is not present, we need to create it
                  self.response = @amenity.amenity_value_create(@rc, attribute_id, hotel_id, attribute_value_create_update, 1033) 
                  handle_errors_in_response
               end
            end
         end
      rescue Exception => e
         puts "There was an exception #{e.message}"
         log_error(hotel_id, attribute_id, attribute_value)
      end
   end

   def upload_attribute_for_room(room_id, attribute_id, attribute_value=nil)
      begin
      rescue Exception => e
         puts "There was an exception #{e.message}"
      end
   end

   def log_error(hotel_id, attribute_id, attribute_value)
      puts "LCMS create/update failed for hotel[#{hotel_id}],attribute[#{attribute_id}],append value[#{attribute_value}]"
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
         error_list = response_get_error_list
         puts "Attribute value update failed for attribute #{attribute_id} with value #{attribute_value} for hotel #{hotel_id}"
         p error_list
      end
   end
end

#Start

au = AttributeUpdate.new
hotels = au.hotels
upload = AttributeUpload.new

hotels.each do |h|
  cid = h.catalog_item_id
  attributes = au.attributes(cid)
  attributes.each do |a|
    unless a.attribute_append_txt.nil?
      upload.upload_attribute_for_hotel(cid, a.attribute_id, a.attribute_append_txt)
    else 
      upload.upload_attribute_for_hotel(cid, a.attribute_id)
    end
    sleep(1)  #LCMS only supports 1 tps, so sleep for 1 second
  end
end
