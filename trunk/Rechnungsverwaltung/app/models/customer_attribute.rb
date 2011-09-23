class CustomerAttribute < ActiveRecord::Base
  
    
   :logo
   :hidden
   :signature
   :address
   :unitprice
   :footer
  
  belongs_to :customer, :dependent => :destroy

  
end
