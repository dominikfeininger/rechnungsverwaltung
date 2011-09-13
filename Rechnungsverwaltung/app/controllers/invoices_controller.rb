class InvoicesController < ApplicationController
  def index #index.html.erb
    @invoices = Invoice.all
  end

  def new #new.html.erb
    @invoice = Invoice.new
  end

  def create #show.html.erb
    @invoice = Invoice.new({:invoicenr => params[:invoicenr], :customer_id => params[:customer_id]})
    if ( @invoice.invoicenr != Invoice.find_by_invoicenr(params[:invoicenr]))
      respond_to do |format|
        if @invoice.save
          format.html { redirect_to(@invoice, :notice => 'Rechnung erstellt') }
        else
          format.html { render :action => "new" }
        end
      end
    end
  end
  
  def show #show.html.erb
    @invoice = Invoice.find(params[:id])
  end

  def custshow #custshow.html.erb
    @customer = Customer.find_by_id(params[:id])
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
  end
end
