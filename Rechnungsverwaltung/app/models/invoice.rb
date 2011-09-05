class Invoice < ActiveRecord::Base
  
  validates :invoicenr, :presence => true
  
  belongs_to :customer
  
  has_many :invoice_posses

end
  