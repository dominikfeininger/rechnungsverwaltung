class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new({:invoicenr => params[:invoicenr], :customer_id => params[:customer_id]})
    if ( @invoice.invoicenr != Invoice.find_by_invoicenr(params[:invoicenr]))
      respond_to do |format|
        if @invoice.save
          format.html { redirect_to(@invoice, :notice => 'Rechnung erstellt') }
        else
          format.html { render :action => "new" }
        end
      end
    else
    end
  end

  def custshow
    v = params[:customerid]
    @invoice = Invoice.find_by_customer_id(v)
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
  end
end
