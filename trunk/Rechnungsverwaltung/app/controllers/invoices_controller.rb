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
  
  
###########################################################################################################################
  def showpdf
    unitprice = params[:unitprice]
    logo = params[:logo]
    address = params[:address]
    signature = params[:signature]
    footer = params[:footer]
    
    #puts"############################################"
    #puts "logo #{logo}"
    #puts "address #{address}"
    #puts "signature #{signature}"
    #puts "footer #{footer}"

    #595 x 842
    @invoice = Invoice.find_by_id(params[:id])
    @customer = Customer.find_by_id(@invoice.customer_id)   
    @address = Address.find_by_customer_id(@customer.id)
    @invoice_posses = InvoicePoss.find_all_by_invoice_id(@invoice.id)
    @filepaths = FilePath.find_by_invoice_id(@invoice.id)
     
    require 'prawn'
    #A4, potrait, margin(top, left&right, bottom)
      pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :portrait, :margin => [20,50,20], :size => 10)
      
      #embed logo
      if logo == "1"
        #puts "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"
        pdf.image('./pic/delphit-logo-rgb.png', :at =>[0,750], :fit => [100,50])
      end   
               
      #delphit address
      if address == "1"
      pdf.bounding_box([0,650], :width => 300, :height => 50) do
        pdf.text "<u>delphit GmbH - Lange Roetterstrasse 45 - 68167 Mannheim</u>", :size => 8, :inline_format => true
      end
      end
         
      #customer address
      pdf.bounding_box([0,600], :width => 150, :height => 150) do
        pdf.text "#{@customer.firstname} #{@customer.lastname}"
        pdf.text "#{@customer.companyname}"
        #pdf.text "#{@customer.email}"
        pdf.text "#{@address.street}"
        pdf.text "#{@address.plz} #{@address.city}"
      end
      
      #invoice data
      pdf.bounding_box([350,650], :width => 300, :height => 100) do
        pdf.text "Rechnungsnummer: #{@invoice.invoicenr}"
        pdf.text "Rechnungsdatum: #{Date.today}"
        pdf.text "Kundennummer: #{@customer.id}"
      end

      pdf.bounding_box([0,500], :width => 600, :height => 600) do
      #invoice positions header 
      
        p = 50
        #d = 250
        d = 300
        q = 70
        u = 70
        t = 70
        #510
      if unitprice =="1"
        #pdf.table([['PosNr:', 'Beschreibung:', 'Menge:', 'EZ Preis:', 'Total:']],  :column_widths =>[p,d,q,u,t])
        pdf.table([['Beschreibung:', 'Menge:', 'EZ Preis:', 'Total:']],  :column_widths =>[d,q,u,t])      
        
        #invoice positions data   
        @invoice_posses.each do |ip|
          #pdf.table([["#{ip.invoiceposnr}", "#{ip.description}", "#{ip.qty}","#{ip.unitprice}", "#{ip.total}"]], :column_widths =>[p,d,q,u,t]) do
          pdf.table([["#{ip.description}", "#{ip.qty}","#{ip.unitprice}", "#{ip.total}"]], :column_widths =>[d,q,u,t]) do
            ip.total
          end
        end
      else
        d = 350
        #pdf.table([['PosNr:', 'Beschreibung:', 'Menge:', 'EZ Preis:', 'Total:']],  :column_widths =>[p,d,q,u,t])
        pdf.table([['Beschreibung:', 'Menge:', 'Total:']],  :column_widths =>[d,q,t])      
        
        #invoice positions data   
        @invoice_posses.each do |ip|
          #pdf.table([["#{ip.invoiceposnr}", "#{ip.description}", "#{ip.qty}","#{ip.unitprice}", "#{ip.total}"]], :column_widths =>[p,d,q,u,t]) do
          pdf.table([["#{ip.description}", "#{ip.qty}", "#{ip.total}"]], :column_widths =>[d,q,t]) do
            ip.total
          end
        end
      end
      end
      
      #greetings
      if signature == "1"
      pdf.bounding_box([0,250], :width => 300, :height => 100) do
        pdf.text "Freundliche Guesse"
      end
      pdf.bounding_box([0,200], :width => 300, :height => 100) do
         pdf.text "Martin Kolb"
      end
      end
      
      #footer
      if footer == "1"
      size = 7
      height = 40
      width =80
     pdf.bounding_box([0,height], :width => width, :height => height) do 
       pdf.text "delphit GmbH", :size => size
       pdf.text "Lange Roetterstrasse 45", :size => size
       pdf.text "68167 Mannheim", :size => size
     end    
     pdf.bounding_box([100,height], :width => width, :height => height) do 
       pdf.text "+49 621 43727263", :size => size
       pdf.text "info@delphit.com", :size => size
       pdf.text "http://www.delphit.com", :size => size
     end
      pdf.bounding_box([200,height], :width => width, :height => height) do 
       pdf.text "Geschaeftsfuehrer:", :size => size
       pdf.text "Martin Kolb", :size => size
       pdf.text "Sebastian Seitz", :size => size
     end
     pdf.bounding_box([300,height], :width => width, :height => height) do 
       pdf.text "VR Bank Mittelhaardt eG", :size => size
       pdf.text "Blz.: 546 912 00", :size => size
       pdf.text "Konto: 117 543 307", :size => size
     end
     pdf.bounding_box([400,height], :width => 100, :height => height) do 
       pdf.text "Amtsgericht Mannheim", :size => size
       pdf.text "Handelsregister: HRB 710643", :size => size
       pdf.text "Ust-IdNr: DE274536868", :size => size
     end 
     end
              
    #create file and file path
    foldername = Date.today.to_s
    foldername = foldername[0,7]
     
    @timestamp = Time.new
    @timestamp = @timestamp.to_formatted_s(:number)
    
    @fp = "./invoices/#{foldername}/"
        
     if File.directory?(@fp)   
         pdf.render_file "#{@fp}#{@invoice.invoicenr}_#{@timestamp}.pdf"    
        sendsave()
     else
        puts "############################# folder desnt exist"
        #create folder
        Dir.mkdir("#{@fp}")
              pdf.render_file "#{@fp}#{@invoice.invoicenr}_#{@timestamp}.pdf"
        sendsave()         
        
     end    
  end
  
  def sendsave           
      send_file "#{@fp}#{@invoice.invoicenr}_#{@timestamp}.pdf ", :type => "application/pdf"
      @filepath = FilePath.new
      @filepath.path = "#{@fp}#{@invoice.invoicenr}_#{@timestamp}.pdf"
      @filepath.invoice_id = @invoice.id
      @filepath.save
  end
 
end
