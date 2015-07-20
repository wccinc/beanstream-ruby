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
      "order_#{prefix}_#{SecureRandom.hex(10)}"
    end

    def make_payment_url
      "#{Beanstream.api_base_url()}/payments/"
    end
    
    def return_payment_url()
      "#{Beanstream.api_base_url()}/return/"
    end
    
    def void_payment_url()
      "#{Beanstream.api_base_url()}/void/"
    end
    
    def make_payment(payment)
      val = transaction_post("POST", make_payment_url, Beanstream.merchant_id, Beanstream.payments_api_key, payment)
    end

  end

end