# encoding: utf-8
require '../room_type'
require '../amenity'
require 'nokogiri'
require 'test/unit'


describe RoomType do
   before(:each) do
      @rc = LCMS::RequestContext.new("1.0","epc","746777")
      @rtn =RoomType.new
   end
   it "should be able to get the right room" do
      resp = @rtn.room_type_get(@rc, 2203502)
      doc = resp.doc
      expected_names = ['Værelse mod syd',"Room South","Zimmer, Süden","Chambre Sud","Camera Sud","ルーム サウス","Kamer, zuiden","Rom, sør","Rum, söderläge","Room South","Chambre orientée sud","Room South"]
      names_from_lcms = []
      names = doc.xpath("//ns2:Name",{"ns2" => "http://expedia.com/lss/contentmasterservice/definitions"})
      names.each do |name|
         name.children.each do |child|
            if(child.node_name == "Value")
               names_from_lcms << child.content 
            end
         end
      end
      puts "____________________________________________________________"
      puts names_from_lcms
      puts "____________________________________________________________"
      names_from_lcms.should =~ expected_names
   end
end

describe Amenity do
   before(:each) do
      @rc = LCMS::RequestContext.new("1.0","epc","746777")
      @amenity = Amenity.new
      @ui = UpdaterInfo.new("SCORE","a-amallya")
      @ac = AttributeCreate.new(@ui)
   end
   it "should be able to return the amenities corresponding to a hotel id" do
      resp = @amenity.amenity_get(@rc,1,5) 
      puts resp
   end

   it "should return the values for a given amenity" do
      resp = @amenity.amenity_value_get(@rc,2020,9,2057) 
      puts resp
   end

end
