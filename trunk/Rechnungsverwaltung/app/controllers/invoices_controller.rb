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
      pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :portrait, :margin => [20,50,20], :size => 10)
      
      #embed logo
      pdf.image('./pic/delphit-logo-rgb.png', :at =>[0,750], :fit => [100,50])
            
      #customer address
      pdf.bounding_box([0,600], :width => 150, :height => 150) do
        pdf.text "#{@customer.firstname} #{@customer.lastname}"
        pdf.text "#{@customer.companyname}"
        pdf.text "#{@customer.email}"
        pdf.text "#{@address.street}"
        pdf.text "#{@address.plz}"
      end
      
      
      #delphit address
      pdf.bounding_box([0,650], :width => 300, :height => 50) do
        pdf.text "<u>delphit GmbH - Lange Roetterstrasse 45 - 68167 Mannheim</u>", :size => 8, :inline_format => true
      end
      
      #invoice data
      pdf.bounding_box([400,650], :width => 200, :height => 50) do
        pdf.text "Rechnungsnummer:"
        pdf.text "#{@invoice.invoicenr}"
      end

      pdf.bounding_box([0,500], :width => 400, :height => 600) do
      #invoice positions header 
      pdf.table([['Positionsnummer:', 'Beschreibung:', 'Menge:', 'Stueckpreis:', 'Total:']])
              
      #invoice positions data   
      @invoice_posses.each do |ip|
        pdf.table([["#{ip.invoiceposnr}", "#{ip.description}", "#{ip.qty}","#{ip.unitprice}", "#{ip.total}"]]) do
          columns(1..3).height = 20
          rows(1..3).width = 72
        end
      end
      end
      
            pdf.render_file "./pdf/invoice #{@invoice.invoicenr}.pdf"

    #redirect_to('./pdf/invoice.pdf', :notice => 'pdf erstellt')
    sendsave()
  end
  
  def sendsave
      send_file "./pdf/invoice #{@invoice.invoicenr}.pdf ", :type => "application/pdf"
  end
  
end
