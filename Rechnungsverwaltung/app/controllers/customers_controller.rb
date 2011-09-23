class CustomersController < ApplicationController
  def index #index.html.erb
    @customers = Customer.all
  end

  def new #new.html.erb
    @customer = Customer.new
  end

  def create 
    cust = params["cust"]
    add = params["add"]
    custatt = params["custatt"]
    
    @customer = Customer.find_by_id(cust[:id])
    #puts "################# #{@customer}"
    if @customer != nil
      @customer.update_attributes(cust)
    else
      @customer = Customer.new(cust)
    end
    
    @address = Address.find_by_id(add[:id])
    if @address != nil
      @address.update_attributes(add)
    else
      @address = Address.create(add)
    end
    
    @customerattribute = CustomerAttribute.find_by_id(custatt[:id])
    if @customerattribute != nil
      @customerattribute.update_attributes(custatt)
    else
      @customerattribute = CustomerAttribute.create(custatt)
    end

    #@customer.addresses << @address
      if @customer.save
         redirect_to(@customer, :notice => 'Kunde erstellt') 
         #save address and attributes
         @address.customer_id = @customer.id
         @address.save
         @customerattribute.customer_id = @customer.id
         @customerattribute.save
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
  
  def update
    
  end
  
  def updateparams
    
    cust = params["cust"]
    add = params["add"]
    custatt = params["custatt"]
    
    @customer = Customer.find_by_id(cust[:id])
    @customer = Customer.update_attributes(cust)
    
    @address = Address.find_by_id(add[:id])
    @address = Address.cupdate_attributes(add)
    
    @customerattibute = CustomerAttribute.find_by_id(custatt[:id])
    @customerattibute = CustomerAttribute.update_attributes(custatt)
    #save address and attributes
   if @customer.save and @address.save and  @customerattibute.save
         redirect_to(@customer, :notice => 'Kunde bearbeitet') 
     else
        render :action => @customer
     end   
  end
end