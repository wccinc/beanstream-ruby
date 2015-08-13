require 'test/unit'
require 'beanstream'
require 'shoulda'

module Beanstream

  class ProfilesAPITest < Test::Unit::TestCase

    setup do
      Beanstream.merchant_id = "300200578"
      Beanstream.payments_api_key = "4BaD82D9197b4cc4b70a221911eE9f70"
      Beanstream.profiles_api_key = "D97D3BE1EE964A6193D17A571D9FBC80"
    end

    should "make profiles url be the same" do
      assert_equal("/api/v1/profiles", ProfilesAPI.new.profile_url())
    end

    should "make profiles/cards url be the same" do
      assert_equal("/api/v1/profiles/cards", ProfilesAPI.new.profile_cards_url())
    end
  end

  class ProfilesAPIIntegrationTest < Test::Unit::TestCase

    setup do
      Beanstream.merchant_id = "300200578"
      Beanstream.payments_api_key = "4BaD82D9197b4cc4b70a221911eE9f70"
      Beanstream.profiles_api_key = "D97D3BE1EE964A6193D17A571D9FBC80"
      @profile = Beanstream.ProfilesAPI.create_profile(
        {
        "billing" => {
        "name" => "Hilary Test",
        "address_line1" => "123 Fake St.",
        "city" => "Victoria",
        "province" => "BC",
        "country" => "CA",
        "postal_code" => "v1v2v2",
        "phone_number" => "12505551234",
        "email_address" => "fake@example.com"
      }
      })
      @card1 = {
        "card" => {
        "name" => "Hilary Test",
        "number" => "4030000010001234",
        "expiry_month" => "07",
        "expiry_year" => "22",
        "cvd" => "123"
      }}

      @card2 = {
        "card" => {
        "name"=>"John Doe",
        "number"=>"5100000010001004",
        "expiry_month"=>"02",
        "expiry_year"=>"14" 
      } }

    end

    should "have successfully created a profile" do
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

    should "have successfully retrieved a profile" do

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

      # now get that profile
      result = Beanstream.ProfilesAPI.get_profile(profile_id)
      assert(result != nil)
      assert(result['billing']['name'] == "Jill Test")

      Beanstream.ProfilesAPI.delete_profile(profile_id) #delete it to clean up
    end

    should "have successfully retrieved a profile" do

      Beanstream.merchant_id = "300200578"
      Beanstream.profiles_api_key = "D97D3BE1EE964A6193D17A571D9FBC80"

      result = Beanstream.ProfilesAPI.create_profile(
        {
        "card" => {
        "name" => "Hilary Test",
        "number" => "4030000010001234",
        "expiry_month" => "07",
        "expiry_year" => "22",
        "cvd" => "123"
      },
        "billing" => {
        "name" => "Hilary Test",
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

      # now get that profile
      profile1 = Beanstream.ProfilesAPI.get_profile(profile_id)
      assert(profile1 != nil)
      assert(profile1['billing']['name'] == "Hilary Test")
      puts "\n\nRetrieved Profile 1:\n\n #{profile1}"

      #update profile
      profile1['billing']['name'] = "gizmo test"
      profile1['language'] = "en"
      profile1['comments'] = "test profile"
      profile1['custom']['ref1'] = "i wish"
      profile1['custom']['ref2'] = "i was"
      profile1['custom']['ref3'] = "an oscar"
      profile1['custom']['ref4'] = "mayer"
      profile1['custom']['ref5'] = "weiner"
      result = Beanstream.ProfilesAPI.update_profile(profile1)

      #get profile again and check the updates
      profile2 = Beanstream.ProfilesAPI.get_profile(profile_id)
      puts "\n\nRetrieved Profile 2:\n\n #{profile2}"
      assert(profile2 != nil)
      assert(profile2['billing']['name'] == "gizmo test")
      assert(profile2['language'] == "en")
      assert(profile2['custom']['ref1'] == "i wish")
      assert(profile2['custom']['ref2'] == "i was")
      assert(profile2['custom']['ref3'] == "an oscar")
      assert(profile2['custom']['ref4'] == "mayer")
      assert(profile2['custom']['ref5'] == "weiner")

      Beanstream.ProfilesAPI.delete_profile(profile_id) #delete it to clean up
    end

    should 'Successfully Add Card' do
      insert_card = Beanstream.ProfilesAPI.add_profile_card(@profile,@card1)
      #Retrieve Profile  again to check if card added
      profile2 = Beanstream.ProfilesAPI.get_profile(@profile['customer_code'])
      assert(profile2['card'])
      assert(insert_card['message']== 'Operation Successful')
    end

    should 'Successfully get Card' do
      add_card = Beanstream.ProfilesAPI.add_profile_card(@profile,@card1)
      card = Beanstream.ProfilesAPI.get_profile_card(@profile)
      assert(card)
      assert(card['message']== 'Operation Successful')
    end

    should 'successfully update card' do
      # Create profile with card 1	
      insert_card = Beanstream.ProfilesAPI.add_profile_card(@profile,@card2)
      # Update profile with card 2
      update_card = Beanstream.ProfilesAPI.update_profile_card(@profile,1,@card1)
      profile2 = Beanstream.ProfilesAPI.get_profile(@profile['customer_code'])
      assert(update_card['message']== 'Operation Successful')
    end

    should 'successfully delete card' do
      # Create profile with card 1	
      insert_card = Beanstream.ProfilesAPI.add_profile_card(@profile,@card2)
      # delete card from profile
      delete_card = Beanstream.ProfilesAPI.delete_profile_card(@profile,1)
      assert(delete_card['message']== 'Operation Successful')
    end
  end
end
