class FilePath < ActiveRecord::Base
  
  :path
  
  belongs_to :invoice
  
end
