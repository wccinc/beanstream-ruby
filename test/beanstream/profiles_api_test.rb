require 'test/unit'
require 'beanstream'
require 'shoulda'

module Beanstream
  
  class ProfilesAPITest < Test::Unit::TestCase

=begin  
    setup do
      Beanstream.merchant_id = "300200578"
      Beanstream.payments_api_key = "4BaD82D9197b4cc4b70a221911eE9f70"
      Beanstream.profiles_api_key = "D97D3BE1EE964A6193D17A571D9FBC80"
    end
=end

    should "canery test print out Beanstream!" do
      puts "Beanstream!"
      assert true
    end
	
    should "make payment url be the same" do
      assert_equal("/api/v1/payments/", PaymentsAPI.new.make_payment_url())
    end
    
    should "make return url be the same" do
      assert_equal("/api/v1/return/", PaymentsAPI.new.return_payment_url())
    end
    
    should "make void url be the same" do
      assert_equal("/api/v1/void/", PaymentsAPI.new.void_payment_url())
    end
  end
  
  class ProfilesAPIIntegrationTest < Test::Unit::TestCase
    should "have successfully created a profile" do
      
      Beanstream.merchant_id = "300200578"
      Beanstream.profiles_api_key = "D97D3BE1EE964A6193D17A571D9FBC80"
      
      result = Beanstream.ProfilesAPI.create_profile(
        {
          "card" => {
            "name" => "Bob Test",
            "number" => "4030000010001234",
            "expiry_month" => "07",
            "expiry_year" => "22",
            "cvd" => "123"
          },
          "billing" => {
            "name" => "Bob Test",
            "address_line1" => "123 Fake St.",
            "city" => "Victoria",
            "province" => "BC",
            "country" => "CA",
            "postal_code" => "v1v2v2",
            "phone_number" => "12505551234",
            "email_address" => "fake@example.com"
          }
        }
      )
      assert(ProfilesAPI.profile_successfully_created(result))
      profile_id = result['customer_code']
      puts "Created profile with ID: #{profile_id}"
    end
    
    should "have successfully deleted a profile" do
      
      Beanstream.merchant_id = "300200578"
      Beanstream.profiles_api_key = "D97D3BE1EE964A6193D17A571D9FBC80"
      
      result = Beanstream.ProfilesAPI.create_profile(
        {
          "card" => {
            "name" => "Jill Test",
            "number" => "4030000010001234",
            "expiry_month" => "07",
            "expiry_year" => "22",
            "cvd" => "123"
          },
          "billing" => {
            "name" => "Jill Test",
            "address_line1" => "123 Fake St.",
            "city" => "Victoria",
            "province" => "BC",
            "country" => "CA",
            "postal_code" => "v1v2v2",
            "phone_number" => "12505551234",
            "email_address" => "fake@example.com"
          }
        }
      )
      assert(ProfilesAPI.profile_successfully_created(result))
      profile_id = result['customer_code']
      puts "Created profile with ID: #{profile_id}"
      
      # now delete the profile
      result = Beanstream.ProfilesAPI.delete_profile(profile_id)
      assert(ProfilesAPI.profile_successfully_deleted(result))
      puts "Deleted profile #{result['customer_code']}"
    end
  end
  
end