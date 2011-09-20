class Invoice < ActiveRecord::Base
  
  validates :invoicenr, :presence => true
  validates :customer_id, :presence =>true
  :filepath
  
  belongs_to :customer
  
  has_many :invoice_posses,  :dependent => :destroy
  has_many :file_paths,  :dependent => :destroy

end
  