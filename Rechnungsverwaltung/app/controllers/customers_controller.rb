class CustomersController < ApplicationController
  def index
    @customers = Customer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customers }
    end
  end

  def new
    @customer = Customer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  def create
    @customer = Customer.new(params[:customer])
    
    @address = Address.create(params[:address])
    @customer.addresses << @address
    
    @invoice = Invoice.create(params[:invoice])
    @customer.invoices << @invoice

    respond_to do |format|
      if @customer.save
        format.html { redirect_to(@customer, :notice => 'Kunde erstellt') }
        format.xml  { render :xml => @customer, :status => :created, :location => @customer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to(customers_path) }
      format.xml  { head :ok }
    end
  end
end