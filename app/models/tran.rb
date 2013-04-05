require "rubygems"
require "active_merchant"

ActiveMerchant::Billing::Base.mode = :test

GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(
    :login => "viren.paladion.livia-facilitator_api1.gmail.com",
    :password => "1364208542",
    :signature => "A8XA83khSMlHFo77pivlaERgOuWPAjPJvucAMbP2zfApa1fQpDWtlcix"
  )



  def purchase_options
    {
      :ip => '127.0.0.1',
      :return_url => "http://localhost:3000/return",
      :cancel_return_url => "http://localhost:3000/cancel" 
    }
  end

card_type = "visa"
card_number= "4111111111111111"
first_name = "Prasad"
last_name = "Gawde"
month_expiry = 12
year_expiry = 2014
card_verification = "123"
credit_card = ActiveMerchant::Billing::CreditCard.new(
           :type               => card_type,
           :number             => card_number,
           :verification_value => card_verification,
           :month          =>   month_expiry,
           :year           => year_expiry,
           :first_name         => first_name,
           :last_name          => last_name
   )


response = GATEWAY.setup_purchase(1000,purchase_options)
p GATEWAY.redirect_url_for(response.token)