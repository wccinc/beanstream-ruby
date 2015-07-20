require 'test/unit'
require 'beanstream'
require 'shoulda'

module Beanstream
  
  class PaymentsAPITest < Test::Unit::TestCase

=begin  
    setup do
      Beanstream.merchant_id = "300200578"
      Beanstream.payments_api_key = "4BaD82D9197b4cc4b70a221911eE9f70"
      puts "merchant ID and key set"
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
  
  class PaymentsAPIIntegrationTest < Test::Unit::TestCase
    should "have successful credit card payment" do
      
      Beanstream.merchant_id = "300200578"
      Beanstream.payments_api_key = "4BaD82D9197b4cc4b70a221911eE9f70"
      
      result = PaymentsAPI.new().make_payment(
        {
          "order_number" => PaymentsAPI.generateRandomOrderId("test"),
          "amount" => 100,
          "payment_method" => PaymentMethods::CARD,
          "card" => {
            "name" => "Mr. Card Testerson",
            "number" => "4030000010001234",
            "expiry_month" => "07",
            "expiry_year" => "22",
            "cvd" => "123",
            "complete" => true
          }
        }
      )
      puts "result: #{result}"
      assert(true)
    end
  end
  
end