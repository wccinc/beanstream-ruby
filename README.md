# Beanstream's Ruby SDK

Integration with Beanstream’s payments gateway is a simple, flexible solution.

You can choose between a straightforward payment requiring very few parameters; or, you can customize a feature-rich integration.

To assist as a centralized record of all your sales, we also accept cash and cheque transactions.

For very detailed information on the Payments API, look at the Beanstream developer portal's [documentation](http://developer.beanstream.com/documentation/take-payments/purchases-pre-authorizations/).

# Setup
To install the SDK you just need to simply install the gem file:
```
gem install beanstream --pre
```

# Code Sample
Take a credit card Payment:
```ruby
begin
  result = Beanstream.PaymentsAPI.make_payment(
  {
    :order_number => PaymentsAPI.generateRandomOrderId("test"),
    :amount => 100,
    :payment_method => PaymentMethods::CARD,
    :card => {
      :name => "Mr. Card Testerson",
      :number => "4030000010001234",
      :expiry_month => "07",
      :expiry_year => "22",
      :cvd => "123",
      :complete => true
    }
  })
  puts "Success! TransactionID: #{result['id']}"
  
rescue BeanstreamException => ex
  puts "Exception: #{ex.user_facing_message}"
end
```

If you would like to contribute to it and earn some cash from our code bounty program please contact bowens@beanstream.com

# Reporting Issues
Found a bug or want a feature improvement? Create a new Issue here on the github page, or email Beanstream support support@beanstream.com
