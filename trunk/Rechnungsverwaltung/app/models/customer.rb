class Customer < ActiveRecord::Base
  
   :firstname
   :lastname
  validates :companyname, :presence => true
  validates :email, :presence => true
  
  has_many :addresses, :dependent => :destroy
  has_many :invoices,  :dependent => :destroy
end
  