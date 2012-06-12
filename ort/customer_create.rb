require './occ_base'

class CustomerCreate < OCC::OCCBase

  def create_ar_customer_sle(header, customer)
    response = @client.request "wsdl:CreateARCustomerRequest", "wsdl:version" => "6.0" do
      soap.body = {
        "wsdl:Header" => header,
        "wsdl:Customer" => customer,
        :order! => ["wsdl:Header","wsdl:Customer"]
      }
    end
  end

  def create_ar_customer_property(header, customer, relationships)
    response = @client.request "wsdl:CreateARCustomerRequest", "wsdl:version" => "6.0" do
      soap.body = {
        "wsdl:Header" => header,
        "wsdl:Customer" => customer,
        "wsdl:Relationship" => relationships,
        :order! => ["wsdl:Header", "wsdl:Customer", "wsdl:Relationship"]
      }
    end
  end
end
