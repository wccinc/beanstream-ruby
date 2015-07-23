
module Beanstream
  
  class ProfilesAPI < Transaction

    def profile_url
      "#{Beanstream.api_base_url()}/profiles"
    end
    
    def profile_cards_url()
      "#{Beanstream.api_base_url()}/profiles/cards"
    end
    
    def create_profile(profile)
      val = transaction_post("POST", profile_url, Beanstream.merchant_id, Beanstream.profiles_api_key, profile)
    end
    
    def delete_profile(profileId)
      delUrl = profile_url+"/"+profileId
      val = transaction_post("DELETE", delUrl, Beanstream.merchant_id, Beanstream.profiles_api_key, nil)
    end

    def self.profile_successfully_created(response)
      success = response['code'] == 1 && response['message'] == "Operation Successful"
    end
    
    def self.profile_successfully_deleted(response)
      success = response['code'] == 1 && response['message'] == "Operation Successful"
    end
  end

end