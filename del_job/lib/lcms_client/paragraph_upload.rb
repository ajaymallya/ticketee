require './paragraph'

class ParagraphUpload
   attr_reader :ui, :rc
   attr_accessor :response, :paragraph 

   def initialize(ui)
      @ui = ui
      @rc = LCMS::RequestContext.new(1.0, "epc", "4599626---fbe7d5d1-e107-4811-8863-605eb654e277")
      @paragraph = Paragraph.new
   end

   def upload_paragraph(order_rank, owner_id, section_id, language, paragraph_type, text, start_date=nil, end_date=nil, media_id=nil, media_size=nil)
      begin
         self.response = paragraph.paragraph_get(rc, owner_id, section_id, language, order_rank)
         if response_contains_errors?
            error_code = response_get_error_code
            if error_code == "1301"
               #Paragraph not found in LCMS ---create it.
               puts "Paragraph not found in LCMS for owner #{owner_id}, with section #{section_id} -- creating"
               paragraph_create = ParagraphCreateUpdate.new(paragraph_type, order_rank, text, start_date, end_date, media_id, media_size, ui) 
               self.response = paragraph.paragraph_create(rc, paragraph_create, owner_id, section_id, language)
               handle_errors_in_response
            end
         else
            #The paragraph exists in LCMS ---- update it
            paragraph_update = ParagraphCreateUpdate.new(paragraph_type, 1, text, start_date, end_date, media_id, media_size, ui)
            self.response = paragraph.paragraph_update(rc, paragraph_update, owner_id, section_id, language)
            handle_errors_in_response
         end
   
      rescue Exception => e
         puts "There was an exception #{e.message}"
         #log_error(owner_id, attribute_id, attribute_value)
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
         #Change this
         puts "Attribute value update failed for attribute #{attribute_id} with value #{attribute_value} for hotel #{hotel_id}"
         p error_list
      end
   end
end
