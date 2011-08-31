class Address < ActiveRecord::Base
  
  validates :city,  :presence => true
  validates :plz, :presence => true
  validates :street, :presence => true
  
  belongs_to :customer
end