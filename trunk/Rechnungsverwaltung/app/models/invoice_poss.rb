class InvoicePoss < ActiveRecord::Base
  
  validates :invoiceposnr, :presence => true
  validates :description, :presence => true
  validates :total, :presence => true
  validates :qty, :presence => true
  validates :unitprice, :presence => true
   :mwst

  belongs_to :invoice

end
