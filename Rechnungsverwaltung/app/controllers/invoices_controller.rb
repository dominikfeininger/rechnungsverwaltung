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
        if @invoice.save
           redirect_to(@invoice, :notice => 'Rechnung erstellt')
        else
            render :action => "new"
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
    redirect_to( :action => :index)
  end
  
  def showpdf
    @invoice = Invoice.find_by_id(params[:id])
    @customer = Customer.find_by_id(@invoice.customer_id)   
    @address = Address.find_by_customer_id(@customer.id)
    @invoice_posses = InvoicePoss.find_all_by_invoice_id(@invoice.id)
     
    require 'prawn'
    #A4, potrait, margin(top, left&right, bottom)
      pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :portrait, :margin => [20,50,20])
      
      #customer address
      pdf.bounding_box([0,750], :width => 150, :height => 150) do
        pdf.text "#{@customer.firstname}"
        pdf.text "#{@customer.lastname}"
        pdf.text "#{@customer.companyname}"
        pdf.text "#{@customer.email}"
        pdf.text "#{@address.street}"
        pdf.text "#{@address.plz}"
      end
      
      
      #delphit address
      pdf.bounding_box([300,750], :width => 150, :height => 150) do
        pdf.text "Martin"
        pdf.text "Kolb"
        pdf.text "delphit Gmbh"
        pdf.text "martin.kolb@delphit.com"
        pdf.text "Kepplerstr. 17"
        pdf.text "69162"
      end
      
      #invoice data
      pdf.bounding_box([0,500], :width => 200, :height => 50) do
        pdf.text "Rechnungsnummer:"
        pdf.text "#{@invoice.invoicenr}"
      end

      #invoice positions header 
      pdf.table([['Positionsnummer:', 'Beschreibung:', 'Menge:', 'Stueckpreis:', 'Total:']])
              
      #invoice positions data   
      @invoice_posses.each do |ip|
        pdf.table([["#{ip.invoiceposnr}", "#{ip.description}", "#{ip.qty}","#{ip.unitprice}", "#{ip.total}"]]) do
          columns(1..3).height = 20
          rows(1..3).width = 72
        end
      end
      
      pdf.render_file "./pdf/invoice.pdf"

    #redirect_to('./pdf/invoice.pdf', :notice => 'pdf erstellt')
    sendsave()
  end
  
  def sendsave
      send_file './pdf/invoice.pdf', :type => "application/pdf"
  end
  
end
