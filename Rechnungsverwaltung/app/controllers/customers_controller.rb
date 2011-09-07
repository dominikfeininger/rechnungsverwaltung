class CustomersController < ApplicationController
  def index
    @customers = Customer.all
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(params[:customer])
    
    @address = Address.create(params[:address])
    @customer.addresses << @address

    respond_to do |format|
      if @customer.save
        format.html { redirect_to(@customer, :notice => 'Kunde erstellt') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
  end
end