class Customer < ActiveRecord::Base
  
  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :companyname, :presence => true
  
  has_many :addresses, :dependent => :destroy
end
  