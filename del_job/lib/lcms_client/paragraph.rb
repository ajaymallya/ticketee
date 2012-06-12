$: << File.dirname(__FILE__)
require 'lcms'

class ParagraphCreateUpdate
   def initialize(type, order_rank, value, effective_start_date, effective_end_date, media_id, mediaSize, updater_info)
      @type = type
      @order_rank = order_rank
      @value = value
      @effective_start_date = effective_start_date
      @effective_end_date = effective_end_date
      @media_id = media_id
      @mediaSize = mediaSize
      @updater_info = updater_info
   end
   def to_s 
      "<ins0:Type>#{@type}</ins0:Type><ins0:OrderRank>#{@order_rank}</ins0:OrderRank><ins0:Value><![CDATA[#{@value}]]></ins0:Value><ins0:UpdaterInfo>#{@updater_info}</ins0:UpdaterInfo>"
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


class Paragraph < LCMS::LCMSBase
   def paragraph_get(request_context, content_owner_id, section_id, language, order_rank)
      response = @client.request "ParagraphGetRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:ContentOwnerID" => content_owner_id,
            "ins0:SectionID" => section_id,
            "ins0:Language" => language,
            "ins0:OrderRank" => order_rank
         }
      end
      response
   end

   def paragraph_create(request_context, paragraph_create, content_owner_id, section_id, language)
      response = @client.request "ParagraphCreateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:Paragraph" => paragraph_create,
            :attributes! => {"ins0:Paragraph" => {"contentOwnerID" => content_owner_id, "sectionID" => section_id, "language" => language}}
         }
      end
      response
   end

   def paragraph_update(request_context, paragraph_update, content_owner_id, section_id, language)
      response = @client.request "ParagraphUpdateRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:Paragraph" => paragraph_update,
            :attributes! => {"ins0:Paragraph" => {"contentOwnerID" => content_owner_id, "sectionID" => section_id, "language" => language}}
         }
      end
      response
   end
      
   def paragraph_delete(request_context, section_id, language, order_rank, updater_info)
      response = @client.request "ParagraphDeleteRQ" do
         soap.body = {
            "ins0:RequestContext" => request_context,
            "ins0:SectionID" => section_id,
            "ins0:Language" => language,
            "ins0:OrderRank" => order_rank,
            "ins0:UpdaterInfo" => updater_info
         }
      end
      response
   end
end
