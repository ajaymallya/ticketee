require 'active_record'

CHC_IMPORT_TOOLS_USERNAME = 'expedia_import_tools_ar'
CHC_IMPORT_TOOLS_PASSWORD = '@ctive0resource'

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
                                        :conditions => " display_rank > 0 AND locked_flag = 'N' and import_type_id = 3",
                                        :order => "catalog_item_id")
  end
  
  def attributes(catalog_item_id)
    attributes = HotelAttributeImports.find(:all,
                                            :conditions => [" display_rank > 0 AND locked_flag = 'Y' AND import_type_id = 3 and catalog_item_id = ?", catalog_item_id],
                                            :order => "catalog_item_id, section_type_id, attribute_name")
  end
end

