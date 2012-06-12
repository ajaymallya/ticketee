require 'savon'

module OCC
  DOCUMENT_URL = "https://wscbnuat.karmalab.net/services/arinboundcreatecustprocess_client?wsdl"
  SERVICE_ENDPOINT = "https://wscbnuat.karmalab.net/services/arinboundcreatecustprocess_client/"

  class Header
    attr_accessor :source_system, :process_id, :process_date
    def initialize(source_system, process_id, process_date) 
      @source_system = source_system
      @process_id = process_id
      @process_date = process_date  
    end

    def to_s
      "<wsdl:SourceSystem>#{@source_system}</wsdl:SourceSystem><wsdl:ProcessId>#{@process_id}</wsdl:ProcessId><wsdl:ProcessDate>#{@process_date}</wsdl:ProcessDate>"
    end
  end

  class OCCBase
    def initialize
      Savon.configure do |config|
        #config.log = false
      end
      #HTTPI.log = false
      @client = Savon::Client.new do 
        wsdl.document = DOCUMENT_URL
        wsdl.endpoint = SERVICE_ENDPOINT
        http.auth.ssl.verify_mode = :none
      end
    end
  end

  class Profile
    attr_accessor :account_status, :acct_status_reason, :invoice_type
    def initialize(account_status, acct_status_reason, invoice_type)
      @account_status = account_status
      @acct_status_reason = acct_status_reason
      @invoice_type = invoice_type
    end
    def to_s
      "<wsdl:AccountStatus>#{@account_status}</wsdl:AccountStatus><wsdl:AcctStatusReason>#{@acct_status_reason}</wsdl:AcctStatusReason><wsdl:InvoiceType>#{@invoice_type}</wsdl:InvoiceType>"
    end
  end


  class Site
    attr_accessor :primary_site, :purpose, :address1, :city, :county, :state, :post_code, :country
    def initialize(primary_site, purpose, address1, city, county, state, post_code, country)
      @primary_site = primary_site
      @purpose = purpose
      @address1 = address1
      @city = city
      @county = county
      @state = state
      @post_code = post_code
      @country = country
    end

    def to_s
      "<wsdl:PrimarySite>#{@primary_site}</wsdl:PrimarySite><wsdl:Purpose>#{@purpose}</wsdl:Purpose><wsdl:Address1>#{@address1}</wsdl:Address1><wsdl:City>#{@city}</wsdl:City><wsdl:County>#{@county}</wsdl:County><wsdl:State>#{@state}</wsdl:State><wsdl:PostCode>#{@post_code}</wsdl:PostCode><wsdl:Country>#{@country}</wsdl:Country>"
    end
  
  end

  class PaymentMethod
    attr_accessor :payment_method, :billing_currency, :primary_paymenthod
    def initialize(payment_method, billing_currency, primary_paymenthod)
      @payment_method = payment_method
      @billing_currency = billing_currency
      @primary_paymenthod = primary_paymenthod
    end

    def to_s
      "<wsdl:PaymentMethod>#{@payment_method}</wsdl:PaymentMethod><wsdl:BillingCurrency>#{@billing_currency}</wsdl:BillingCurrency><wsdl:PrimaryPaymenthod>#{@primary_paymenthod}</wsdl:PrimaryPaymenthod>"
    end
  end

  class Contact
    attr_accessor :primary_contact, :contact_role, :contact_first_name, :contact_last_name, :salutation, :email_address, :phone_type, :phone_number, :phone_area_code, :phone_extension, :phone_country_code, :pref_language
    def initialize(primary_contact, contact_role, contact_first_name, contact_last_name, salutation, email_address, phone_type, phone_number, phone_area_code, phone_extension, phone_country_code, pref_language)
      @primary_contact = primary_contact
      @contact_role = contact_role
      @contact_first_name = contact_first_name
      @contact_last_name = contact_last_name
      @salutation = salutation
      @email_address = email_address
      @phone_type = phone_type
      @phone_number = phone_number
      @phone_area_code = phone_area_code
      @phone_extension = phone_extension
      @phone_country_code = phone_country_code
      @pref_language = pref_language
    end
    def to_s
      "<wsdl:PrimaryContact>#{@primary_contact}</wsdl:PrimaryContact><wsdl:ContactRole>#{@contact_role}</wsdl:ContactRole><wsdl:ContactFirstName>#{@contact_first_name}</wsdl:ContactFirstName><wsdl:ContactLastName>#{@contact_last_name}</wsdl:ContactLastName><wsdl:Salutation>#{@salutation}</wsdl:Salutation><wsdl:EmailAddress>#{@email_address}</wsdl:EmailAddress><wsdl:PhoneType>#{@phone_type}</wsdl:PhoneType><wsdl:PhoneNumber></wsdl:PhoneNumber><wsdl:PhoneAreaCode>#{@phone_area_code}</wsdl:PhoneAreaCode><wsdl:PhoneExtension>#{@phone_extension}</wsdl:PhoneExtension><wsdl:PhoneCountryCode>#{@phone_country_code}</wsdl:PhoneCountryCode><wsdl:PrefLanguage>#{@pref_language}</wsdl:PrefLanguage>"
    end
  end

  class Customer
    attr_accessor :customer_level, :customer_type, :legacy_system_name, :legacy_customer_ref, :customer_name, :customer_status, :customer_alias, :person_flag, :person_first_name, :person_last_name, :tax_reg_number, :tax_reg_type, :profile, :site, :payment_method, :source_customer_ref, :business_model_code, :source_parent_customer_ref, :contact
    def initialize(customer_level, customer_type, legacy_system_name, legacy_customer_ref,  source_parent_customer_ref, customer_name, customer_status, customer_alias, person_flag, tax_reg_number, tax_reg_type, profile, site, payment_method )
      @customer_level = customer_level
      @customer_type = customer_type
      @legacy_system_name = legacy_system_name
      @legacy_customer_ref = legacy_customer_ref
      @source_parent_customer_ref = source_parent_customer_ref
      @customer_name = customer_name
      @customer_status = customer_status
      @customer_alias = customer_alias
      @person_flag = person_flag
      @tax_reg_number = tax_reg_number
      @tax_reg_type = tax_reg_type
      @profile = profile
      @site = site
      @payment_method = payment_method
    end

    def to_s
    "<wsdl:CustomerLevel>#{@customer_level}</wsdl:CustomerLevel><wsdl:CustomerType>#{@customer_type}</wsdl:CustomerType><wsdl:LegacySystemName>#{@legacy_system_name}</wsdl:LegacySystemName><wsdl:LegacyCustomerRef>#{@legacy_customer_ref}</wsdl:LegacyCustomerRef><wsdl:SourceParentCustomerRef>#{@source_parent_customer_ref}</wsdl:SourceParentCustomerRef><wsdl:CustomerName>#{@customer_name}</wsdl:CustomerName><wsdl:CustomerStatus>#{@customer_status}</wsdl:CustomerStatus><wsdl:CustomerAlias>#{@customer_alias}</wsdl:CustomerAlias><wsdl:PersonFlag>#{@person_flag}</wsdl:PersonFlag><wsdl:TaxRegNumber>#{@tax_reg_number}</wsdl:TaxRegNumber><wsdl:TaxRegType>#{@tax_reg_type}</wsdl:TaxRegType><wsdl:profile>#{@profile}</wsdl:profile><wsdl:Site>#{@site}</wsdl:Site><wsdl:PaymentMethod>#{@payment_method}</wsdl:PaymentMethod>"
    end
  end

  class Relationship
    def initialize(subject_customer_ref, subject_customer_type, subject_business_mode_code, subject_relationship_type, child_customer_ref, child_customer_type, child_business_mode_code)
      @subject_customer_ref = subject_customer_ref
      @subject_customer_type = subject_customer_type
      @subject_business_mode_code = subject_business_mode_code
      @subject_relationship_type = subject_relationship_type
      @child_customer_ref = child_customer_ref
      @child_customer_type = child_customer_type
      @child_business_mode_code = child_business_mode_code
    end

    def to_s
      "<wsdl:SubjectCustomerRef>#{@subject_customer_ref}</wsdl:SubjectCustomerRef><wsdl:SubjectCustomerType>#{@subject_customer_type}</wsdl:SubjectCustomerType><wsdl:SubjectBusinessModeCode>#{@subject_business_mode_code}</wsdl:SubjectBusinessModeCode><wsdl:SubjectRelationshipType>#{@subject_relationship_type}</wsdl:SubjectRelationshipType><wsdl:ChildCustomerRef>#{@child_customer_ref}</wsdl:ChildCustomerRef><wsdl:ChildCustomerType>#{@child_customer_type}</wsdl:ChildCustomerType><wsdl:ChildBusinessModeCode>#{@child_business_mode_code}</wsdl:ChildBusinessModeCode>"
    end
  end
end
