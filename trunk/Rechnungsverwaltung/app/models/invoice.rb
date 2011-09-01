class Invoice < ActiveRecord::Base
  
  validates :invoicenr, :presence => true
  
  belongs_to :customer

end
  