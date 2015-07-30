require 'securerandom'

module Beanstream

  class PaymentMethods
    CARD = "card"
    CASH = "cash"
    CHEQUE = "cheque"
    TOKEN = "token"
    PROFILE = "payment_profile"
  end
  
  class PaymentsAPI < Transaction
  
    def self.generateRandomOrderId(prefix)
      "#{prefix}_#{SecureRandom.hex(8)}"
    end

    
    # Urls
    
    def make_payment_url
      "#{Beanstream.api_base_url()}/payments/"
    end
    
    def payment_returns_url(transaction_id)
      "#{Beanstream.api_base_url}/payments/#{transaction_id}/returns"
    end
    
    def payment_void_url(transaction_id)
      "#{Beanstream.api_base_url}/payments/#{transaction_id}/void"
    end
    
    def get_transaction_url(transaction_id)
      "#{Beanstream.api_base_url}/payments/#{transaction_id}"
    end
    
    
    #API operations
    
    def make_payment(payment)
      val = transaction_post("POST", make_payment_url, Beanstream.merchant_id, Beanstream.payments_api_key, payment)
    end
    
    def complete_preauth(transaciton_id, amount)
      complete_url = make_payment_url+transaciton_id+"/completions"
      completion = { "amount" => amount }
      val = transaction_post("POST", complete_url, Beanstream.merchant_id, Beanstream.payments_api_key, completion)
    end

    def self.payment_approved(payment_response)
      success = payment_response['approved'] == "1" && payment_response['message'] == "Approved"
    end
    
    def get_legato_token(card_info)
      turl = "/scripts/tokenization/tokens"
      result = Transaction.new().transaction_post("POST", turl, "", "", card_info)
      token = result['token']
    end

    def get_transaction(transaction_id)
      transaction_post("GET", get_transaction_url(transaction_id), Beanstream.merchant_id, Beanstream.payments_api_key)
    end

    def return_payment(transaction_id, amount)
      data = { amount: amount }
      transaction_post("POST", payment_returns_url(transaction_id), Beanstream.merchant_id, Beanstream.payments_api_key, data)
    end

    def void_payment(transaction_id, amount)
      data = { amount: amount }
      transaction_post("POST", payment_void_url(transaction_id), Beanstream.merchant_id, Beanstream.payments_api_key, data)
    end
  
  end

end