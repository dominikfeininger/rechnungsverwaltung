class InvoicePossesController < ApplicationController
  def index
    @invoiceposses = InvoicePoss.all
  end

  def new
    @invoiceposs = InvoicePoss.new
  end

  def create #show
    #get number of pos from view
    x = params[:position_count].to_i
    #loop through all pos
    x.times  do |i|
      #get the current pos in the iparams val 
      iparams = params["pos#{i}"]
      #search for pos_id
      if iparams.has_key?(:position_id)
        #already exists
        @invoiceposs = InvoicePoss.find_by_id(iparams[:position_id])
        #delete attribut position_id
        iparams.delete(:position_id)
        @invoiceposs.update_attributes(iparams)
      else
        #does not exist - create new
        @invoiceposs = InvoicePoss.new(iparams)
      end
      #save
      @invoiceposs.save
    end
    #path to show invoice with current id
    redirect_to :controller => :invoices, :action => :show, :id => params[:invoice_id]
    #redirect_to invoices_path(:id => params[:invoice_id])
    
    
  end


  def destroy
    @invoiceposs = InvoicePoss.find(params[:id])
    @invoiceposs.destroy
  end
end
