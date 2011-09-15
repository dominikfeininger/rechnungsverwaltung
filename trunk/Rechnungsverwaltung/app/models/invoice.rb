class Invoice < ActiveRecord::Base
  
  validates :invoicenr, :presence => true
  validates :customer_id, :presence =>true
  belongs_to :customer
  
  has_many :invoice_posses,  :dependent => :destroy

end
  