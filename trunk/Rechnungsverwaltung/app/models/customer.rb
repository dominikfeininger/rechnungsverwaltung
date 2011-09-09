class Customer < ActiveRecord::Base
  
  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :companyname, :presence => true
  validates :email, :presence => true
  
  has_many :addresses, :dependent => :destroy
  has_many :invoices,  :dependent => :destroy
end
  