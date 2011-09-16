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
    @invoice_posses = InvoicePoss.find_by_invoice_id(@invoice.id)
     
    require 'prawn'
    #A4, potrait, margin(top, left&right, bottom)
      pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :portrait, :margin => [20,100,20])
      
      #customer address
      pdf.bounding_box([20,700], :width => 150, :height => 150) do
        pdf.text "#{@customer.firstname}"
        pdf.text "#{@customer.lastname}"
        pdf.text "#{@customer.companyname}"
        pdf.text "#{@customer.email}"
        pdf.text "#{@address.street}"
        pdf.text "#{@address.plz}"
      end
      
      
      #delphit address
      pdf.polygon [0,250], [300,700], [150,150]
      pdf.bounding_box([300,700], :width => 150, :height => 150) do
        pdf.text "Martin"
        pdf.text "Kolb"
        pdf.text "delphit Gmbh"
        pdf.text "martin.kolb@delphit.com"
        pdf.text "Kepplerstr. 17"
        pdf.text "69162"
      end
      
      #invoice data
      pdf.bounding_box([20,500], :width => 200, :height => 50) do
        pdf.text "Rechnungsnummer:"
        pdf.text "#{@invoice.invoicenr}"
      end
      
      #invoice positions data
      # pdf.table(data) do |table|
        # table.row_length(5)
        # table.column_length(5)
      # end
      
      pdf.bounding_box([200,200], :width => 600, :height => 600) do
        pdf.text "Positionsnummer: "
        pdf.text "Beschreibung: "
        pdf.text "Menge: "
        pdf.text "Stueckpreis: "
        pdf.text "Total: "
        
        pdf.text "#{@invoice_posses.invoiceposnr}"
        pdf.text "#{@invoice_posses.description}"
        pdf.text "#{@invoice_posses.qty}"
        pdf.text "#{@invoice_posses.unitprice}"
        pdf.text "#{@invoice_posses.total}"
      end
      
      
      pdf.render_file "./pdf/invoice.pdf"

    #redirect_to('./pdf/invoice.pdf', :notice => 'pdf erstellt')
    sendsave()
  end
  
  def sendsave
      send_file './pdf/invoice.pdf', :type => "application/pdf"
  end
  
end
