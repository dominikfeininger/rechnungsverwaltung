class CustomersController < ApplicationController
  def index #index.html.erb
    @customers = Customer.all
  end

  def new #new.html.erb
    @customer = Customer.new
  end

  def create 
    @customer = Customer.new(params[:customer])
    
    @address = Address.create(params[:address])
    @customer.addresses << @address
      if @customer.save
         redirect_to(@customer, :notice => 'Kunde erstellt') 
      else
        render :action => "new" 
      end
  end

  def show #show.html.erb
    @customer = Customer.find(params[:id])
  end

  def destroy 
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to( :action => :index)
  end
end