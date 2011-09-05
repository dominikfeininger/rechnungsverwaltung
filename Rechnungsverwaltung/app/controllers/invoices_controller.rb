class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
    end
  end

  def new
    @invoice = Invoice.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invoice }
    end
  end

  def create

    @invoice = Invoice.new(params[ :invoice])
    
    @invoicepos = InvoicePoss.create(params[ :invoicepos])
        
    @invoice.customer_id = (params[ :customer] [:id])
    #@invoice.invoice_posses_id = (params[ :invoice_poss] [:id])
    @invoice.invoice_posses << @invoicepos

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to(@invoice, :notice => 'Rechnung erstellt') }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invoice }
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(invoices_path) }
      format.xml  { head :ok }
    end
  end
end
