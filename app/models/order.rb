class Order < ActiveRecord::Base
  attr_accessible :card_expires_on, :card_type, :cart_id, :first_name, :ip_address, :last_name, :new, :card_number, :card_verification
  attr_accessor :card_number, :card_verification, :express_token,:express_payer_id
  attr_accessible :card_number, :card_verification, :express_token,:express_payer_id

  has_many :transactions, :class_name => "OrderTransaction"
  
  

  def purchase
    binding.pry
    
    response = ::GATEWAY.setup_purchase(1000,purchase_options)
    transactions.create!(:action => "purchase" ,:response => response)
  end


  def purchase_options
    binding.pry
    {
      :ip => '127.0.0.1',
      :return_url => "http://localhost:3000/return",
      :cancel_return_url => "http://localhost:3000/cancel" 
    }
  end
   
  def express_token=(token)
    binding.pry
    self[:express_token]= token
  if new_record? && !token.blank?
    details = GATEWAY.details_for(token)
    self.express_payer_id = details.payer_id
    self.first_name = details.params["first_name"]
    self.last_name = details.params["last_name"]

  end
end
  
  def credit_card

    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year,
      :first_name         => first_name,
      :last_name          => last_name
    )
  end


end