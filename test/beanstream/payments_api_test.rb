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
      
      result = Beanstream.PaymentsAPI.make_payment(
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
      
      assert(PaymentsAPI.payment_approved(result))
      transaction_id = result['id']
      puts "TransactionId: #{transaction_id}"

      # => new test get payments
      result = Beanstream.PaymentsAPI.get_transaction(transaction_id)
      puts "Get Payments Result:"
      puts result
      assert result["approved"] == 1
      assert result["message"]  == "Approved"
      # end new test
    end
    
    should "purchase successfully with a legato token" do
      
      Beanstream.merchant_id = "300200578"
      Beanstream.payments_api_key = "4BaD82D9197b4cc4b70a221911eE9f70"
      
      token = Beanstream.PaymentsAPI.get_legato_token(
        {
          "number" => "4030000010001234",
          "expiry_month" => "07",
          "expiry_year" => "22",
          "cvd" => "123"
        }
      )
      puts "token result: #{token}"
      assert(token != nil)

      result = Beanstream.PaymentsAPI.make_payment(
        {
          "order_number" => PaymentsAPI.generateRandomOrderId("test"),
          "amount" => 13.99,
          "payment_method" => PaymentMethods::TOKEN,
          "token" => {
            "name" => "Bobby Test",
            "code" => token,
            "complete" => true
          }
        }
      )
      puts "result: #{result}"
      assert(PaymentsAPI.payment_approved(result))

    end
    
    should "have successful credit card pre-auth and completion" do
      
      Beanstream.merchant_id = "300200578"
      Beanstream.payments_api_key = "4BaD82D9197b4cc4b70a221911eE9f70"
      
      result = Beanstream.PaymentsAPI.make_payment(
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
            "complete" => false
          }
        }
      )
      puts "result: #{result}"
      
      assert(PaymentsAPI.payment_approved(result))
      transaction_id = result['id']
      puts "TransactionId: #{transaction_id}"
      
      result = Beanstream.PaymentsAPI.complete_preauth(transaction_id, 59.50)
      puts "completion result: #{result}"
      assert(PaymentsAPI.payment_approved(result))
    end
    
    should "pre-auth and complete successfully with a legato token" do
      
      Beanstream.merchant_id = "300200578"
      Beanstream.payments_api_key = "4BaD82D9197b4cc4b70a221911eE9f70"
      
      # 1) get token
      token = Beanstream.PaymentsAPI.get_legato_token(
        {
          "number" => "4030000010001234",
          "expiry_month" => "07",
          "expiry_year" => "22",
          "cvd" => "123"
        }
      )
      puts "token result: #{token}"
      assert(token != nil)

      # 2) make pre-auth
      result = Beanstream.PaymentsAPI.make_payment(
        {
          "order_number" => PaymentsAPI.generateRandomOrderId("test"),
          "amount" => 13.99,
          "payment_method" => PaymentMethods::TOKEN,
          "token" => {
            "name" => "Bobby Test",
            "code" => token,
            "complete" => false
          }
        }
      )
      puts "result: #{result}"
      assert(PaymentsAPI.payment_approved(result))
      transaction_id = result['id']

      # 3) complete purchase
      result = Beanstream.PaymentsAPI.complete_preauth(transaction_id, 10.33)
      puts "completion result: #{result}"
      assert(PaymentsAPI.payment_approved(result))
    end
    
  end
  
end