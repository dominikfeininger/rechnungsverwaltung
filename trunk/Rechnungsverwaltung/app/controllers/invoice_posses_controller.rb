class InvoicePossesController < ApplicationController
  def setPosNr
    
  end
  def index
    @invoiceposses = InvoicePoss.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoiceposses }
    end
  end

  def new
    @invoiceposs = InvoicePoss.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invoiceposs }
    end
  end

  def create
    @invoiceposs = InvoicePoss.new(params[ :invoicepos])

    respond_to do |format|
      if @invoiceposs.save
        format.html { redirect_to(@invoiceposs, :notice => 'Position erstellt') }
        format.xml  { render :xml => @invoiceposs, :status => :created, :location => @invoiceposs }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoiceposs.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @invoiceposs = InvoicePoss.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invoiceposs }
    end
  end

  def destroy
    @invoiceposs = InvoicePoss.find(params[:id])
    @invoiceposs.destroy

    respond_to do |format|
      format.html { redirect_to(invoice_posses_path) }
      format.xml  { head :ok }
    end
  end
end
