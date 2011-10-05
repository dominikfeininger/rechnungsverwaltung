class HomeController < ApplicationController
  def index
  end
  
  
  def jquery
    
  end
  
  def test_ajax
    render :partial => 'home/test_partial'
  end
  
end
