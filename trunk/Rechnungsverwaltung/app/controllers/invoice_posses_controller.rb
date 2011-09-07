class InvoicePossesController < ApplicationController

  def index
    @invoiceposses = InvoicePoss.all
  end

  def new
    @invoiceposs = InvoicePoss.new
  end

  def create
    #while new postitions exists
    while params.has_key?("pos#{i}")
      @invoiceposs = InvoicePoss.new({:invoice_id => params["pos#{i}"][:invoice_id], :invoiceposnr => params["pos#{i}"][:invoiceposnr], :qty => params["pos#{i}"][:qty], :description => params["pos#{i}"][:description], :unitprice => params["pos#{i}"][:unitprice], :total => params["pos#{i}"][:total]})
       #position already in database?
      if (@invoiceposs.id != Invoice.find_by_id(params[:id]))
        #save position
        respond_to do |format|
          if @invoiceposs.save
            format.html { redirect_to(@invoiceposs, :notice => 'Position erstellt') }
          else
            format.html { render :action => "new" }
          end
        end
      end
    end
  end

  def show
    @invoiceposs = InvoicePoss.find(params[:id])
  end

  def destroy
    @invoiceposs = InvoicePoss.find(params[:id])
    @invoiceposs.destroy
  end
end
