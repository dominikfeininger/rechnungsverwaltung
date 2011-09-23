#encoding: utf-8
class InvoicesController < ApplicationController
  def index #index.html.erb
    @invoices = Invoice.all
  end
  
  def getnextinvoicenumber
    invoice = Invoice.select("MAX(invoicenr) as maxinvoicenr").first
    #puts "########################### #{invoice.maxinvoicenr}"
    nextinvoicenr = invoice.maxinvoicenr.to_s
    #get year
    year = nextinvoicenr[0..2]
    #puts "####################### #{year}"
    #rise number
    ninr = nextinvoicenr[3..8]
    nextinvoicenr = ninr.to_i
    ninr = nextinvoicenr +1
    nextinvoicenr = ninr.to_s
    ninr = year + nextinvoicenr
    ninr
  end

  def new #new.html.erb
    @invoice = Invoice.new
    @nextinvoicenumber = getnextinvoicenumber()
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
  def savepdf    
    save = 1#params[:save].to_i
    
    #invoiceposs count
    poscount = 0
    mehrwertsteuerhoch = 19
    mehrwertsteuergering = 7
    #table cell padding horizintal
    paddingh = 1
    #table cell padding vertical
    paddingv = 2
    #space between signature and greetings
    spacing = 0
    
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
    #@customerattribute = CustomerAttribute.find_by_customer_id(@customer.id)
    custatt = params["custatt"]
    @customerattribute = CustomerAttribute.create(custatt)
    #puts "######################## #{custatt}"
    #@customerattribute.update_attributes(custatt)
    @sum = 0
    @sum7 = 0
    @sum19 =0
    @mwst19 =0
    @mwst7 =0
     
    require 'prawn'
    #A4, potrait, margin(top, left&right, bottom)
    pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :portrait, :margin => [20,50,20], :size => 10)
    pdf.font("Helvetica")
      
      #embed logo
    if @customerattribute.logo == "1"
      #puts "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"
      pdf.image('./pic/delphit-logo-rgb.png', :at =>[0,780], :fit => [150,80])
    end   
               
     #delphit address
     if @customerattribute.address == "1"
      pdf.bounding_box([0,700], :width => 300, :height => 50) do
        pdf.text "<u>delphit GmbH - Lange Rötterstrasse 45 - 68167 Mannheim</u>", :size => 8, :inline_format => true
        end
     end
         
     #customer address
     pdf.bounding_box([0,670], :width => 150, :height => 150) do
       pdf.text "#{@customer.firstname} #{@customer.lastname}"
       pdf.text "#{@customer.companyname}"
       #pdf.text "#{@customer.email}"
       pdf.text "#{@address.street}"
       pdf.text "#{@address.plz} #{@address.city}"
     end
      
      #invoice data
      pdf.bounding_box([350,700], :width => 100, :height => 100) do
        pdf.text "Rechnungs-Nr.:"
        #DateTime.now.strftime("%d.%m.%Y")
        #pdf.text "Rechnungsdatum: #{Date.today}"
        pdf.text "Rechnungsdatum:"
        pdf.text "Kundennummer:"
      end
       #invoice data
      pdf.bounding_box([450,700], :width => 200, :height => 100) do
        pdf.text "#{@invoice.invoicenr}"
        pdf.text "#{DateTime.now.strftime("%d.%m.%Y")}"
        pdf.text "#{@customer.id}"
      end
      
      #start
      pdf.bounding_box([0,550], :width => 600, :height => 600) do
        #invoice positions header 
      
        #mwst for each row
        @mwsteach = "0"
        @invoice_posses.each do |ip1|
          @invoice_posses.each do |ip2|
            if ip1.mwst == mehrwertsteuergering
              if ip2.mwst == mehrwertsteuerhoch
                @mwsteach = "1"
              end
            end
         end
       end
      
       if @mwsteach == "0"
         #table with possesdata without mwst in pos
         poscount = setinvoicepossesdata(pdf,poscount,mehrwertsteuerhoch,mehrwertsteuergering,paddingh,paddingv)
       else #@mwsteach == "1"
         #table with possesdata with mwst in pos
         poscount = setinvoicepossesdatamwst(pdf,poscount,mehrwertsteuerhoch,mehrwertsteuergering,paddingh,paddingv)
       end
         
        diff = poscount * -17
        if poscount >=11
          spacing = poscount * 5
        end
      
        #clause
        pdf.bounding_box([0,450+diff], :width => 500, :height => 100) do
          pdf.text "Bitte überweisen Sie den Rechnungsbetrag innerhalb von 14 Tagen auf das u.g. Konto"
        end
      
      
        #greetings
        if @customerattribute.signature == "1"
          pdf.bounding_box([0,350+diff+spacing], :width => 300, :height => 100) do
            pdf.text "Freundlichen Grüße"
          end
          pdf.bounding_box([0,300+diff+spacing], :width => 300, :height => 100) do
            pdf.text "Martin Kolb"
          end
        end
#       
      #footer
      if @customerattribute.footer == "1"
        size = 7
        height = 70
        width = 80
      
        pdf.bounding_box([0,height], :width => width, :height => height) do 
          pdf.text "delphit GmbH", :size => size
          pdf.text "Lange Rötterstrasse 45", :size => size
          pdf.text "68167 Mannheim", :size => size
        end    
        pdf.bounding_box([100,height], :width => width, :height => height) do 
          pdf.text "+49 621 43727263", :size => size
          pdf.text "info@delphit.com", :size => size
          pdf.text "http://www.delphit.com", :size => size
        end
        pdf.bounding_box([200,height], :width => width, :height => height) do 
          pdf.text "Geschaeftsführer:", :size => size
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
         
      if save == 1  
                     
        #create file and file path
        foldername = Date.today.to_s
        foldername = foldername[0,7]
       
        @timestamp = Time.new
        @timestamp = @timestamp.to_formatted_s(:number)
      
        @fp = "./invoices/#{foldername}/"
          
        #puts "#######################################"
  
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
        not save 
      else
        #pdf.render_file "#{@fp}#{@invoice.invoicenr}_#{@timestamp}.pdf"
      end 
    end
  end
  
  #create table with mwst
  def setinvoicepossesdatamwst(pdf,poscount,mehrwertsteuerhoch,mehrwertsteuergering,paddingh,paddingv)
     
    #poscount = 0
    #mehrwertsteuerhoch = 19
    #mehrwertsteuergering = 7
    #paddingh = 2
    #paddingv = 2
          
    p = 50
    #d = 250
    d = 230
    q = 75
    u = 75
    t = 75
    m = 40
    #510
        
    #invoice positions data AND unitprice  
    if @customerattribute.unitprice == "1"
       #pdf.table([['PosNr:', 'Beschreibung:', 'Menge:', 'EZ Preis:', 'Total:']],  :column_widths =>[p,d,q,u,t])
       pdf.table([['Leistung(en)', 'Menge', 'EZ Preis', 'Total','Mwst']], :column_widths =>[d,q,u,t,m]) do
          row(0).style(:background_color => 'dddddd', :font_style => :bold, :padding => [paddingh,paddingv])
          #row(0).height = 20
          column(1..4).style(:align => :right)
       end
      
       #invoice positions data WITH unitprice
       @invoice_posses.each do |ip|
          poscount += 1
          #pdf.table([["#{ip.invoiceposnr}", "#{ip.description}", "#{ip.qty}","#{ip.unitprice}", "#{ip.total}"]], :column_widths =>[p,d,q,u,t]) do
          pdf.table([["#{ip.description}", "#{'%.1f' %ip.qty}","#{'%.2f' %ip.unitprice}€", "#{'%.2f' %ip.total}€", "#{'%.0f' %ip.mwst}%"]], :column_widths =>[d,q,u,t,m]) do
            #ip.total
            row(0).style(:padding => [paddingh,paddingv])
            column(1..4).style(:align => :right)
          end
          @sum += ip.total
       end
       
      #empty placeholder
      pdf.table([['','','','']], :column_widths =>[d+q,u,t,m])do
        row(0).height = 5
        row(0).style(:padding => [paddingh,paddingv])
      end
        
      #invoice positions data WITHOUT unitprice
      else
        #pdf.table([['PosNr:', 'Beschreibung:', 'Menge:', 'Total:']],  :column_widths =>[p,d,q,t])
        pdf.table([['Leistung(en)', 'Menge', 'Total', 'Mwst']],  :column_widths =>[d+u,q,t,m]) do
          row(0).style(:background_color => 'dddddd', :font_style => :bold, :padding => [paddingh,paddingv])
          column(1..3).style(:align => :right)
        end     
      
        @invoice_posses.each do |ip|
          poscount += 1
          #pdf.table([["#{ip.invoiceposnr}", "#{ip.description}", "#{ip.qty}","#{ip.unitprice}", "#{ip.total}"]], :column_widths =>[p,d,q,u,t]) do
          pdf.table([["#{ip.description}", "#{'%.1f' %ip.qty}", "#{'%.2f' %ip.total}€", "#{'%.0f' %ip.mwst}%"]], :column_widths =>[d+u,q,t,m]) do
             #ip.total
             row(0).style(:padding => [paddingh,paddingv])
             column(1..3).style(:align => :right)
          end
          @sum += ip.total
        end
        
       #empty placeholder
       pdf.table([['','',"",'']], :column_widths =>[d+u,q,t,m])do
          row(0).height = 5
          row(0).style(:padding => [paddingh,paddingv])
       end 
      end
            
      #puts "######################## #{@sum}"
      #sum
      #"#{'%.2f' % number}"
      pdf.table([['Nettobetrag','',"#{'%.2f' %@sum}€",'']], :column_widths =>[d+q,u,t,m])do
         row(0).style(:align => :right, :padding => [paddingh,paddingv])
      end

          
      @invoice_posses.each do |ip|
         if ip.mwst == mehrwertsteuergering
           @if7 = 1
           @sum7 += ip.total
           @mwst7 =@sum7/100*mehrwertsteuergering
         end
      end
           
      if @if7 == 1
        pdf.table([["Mehrwertsteuer (  #{mehrwertsteuergering},00 %)",'',"#{'%.2f' %@mwst7}€",'']], :column_widths =>[d+q,u,t,m])do
          row(0).style(:align => :right, :padding => [paddingh,paddingv])
        end
      end

      @invoice_posses.each do |ip|
        if ip.mwst == mehrwertsteuerhoch  
           @if19 = 1
           @sum19 +=ip.total        
           @mwst19 =@sum19/100*mehrwertsteuerhoch
        end
      end
      
      if @if19 == 1
         pdf.table([["Mehrwertsteuer (#{mehrwertsteuerhoch},00 %)",'',"#{'%.2f' %@mwst19}€",'']], :column_widths =>[d+q,u,t,m])do
            row(0).style(:align => :right, :padding => [paddingh,paddingv])
         end
      end
  
      @sumbrut = @mwst19+@sum+@mwst7
      pdf.table([["Bruttobetrag",'',"#{'%.2f' %@sumbrut}€",'']], :column_widths =>[d+q,u,t,m])do
         row(0).style(:align => :right, :padding => [paddingh,paddingv])
      end
    poscount
  end
  
  #create table without mwst
  def setinvoicepossesdata(pdf,poscount,mehrwertsteuerhoch,mehrwertsteuergering,paddingh,paddingv)
    
    #poscount = 0
    #mehrwertsteuerhoch = 19
    #mehrwertsteuergering = 7
    #paddingh = 2
    #paddingv = 2
          
    p = 50
    #d = 250
    d = 270
    q = 75
    u = 75
    t = 75
    #510
    
    #invoice positions data AND unitprice  
    if @customerattribute.unitprice == "1"
       #pdf.table([['PosNr:', 'Beschreibung:', 'Menge:', 'EZ Preis:', 'Total:']],  :column_widths =>[p,d,q,u,t])
       pdf.table([['Leistung(en)', 'Menge', 'EZ Preis', 'Total']], :column_widths =>[d,q,u,t]) do
          row(0).style(:background_color => 'dddddd', :font_style => :bold, :padding => [paddingh,paddingv])
          #row(0).height = 20
          column(1..3).style(:align => :right)
       end
       
       @invoice_posses.each do |ip|
          poscount += 1
          #pdf.table([["#{ip.invoiceposnr}", "#{ip.description}", "#{ip.qty}","#{ip.unitprice}", "#{ip.total}"]], :column_widths =>[p,d,q,u,t]) do
          pdf.table([["#{ip.description}", "#{'%.1f' %ip.qty}","#{'%.2f' %ip.unitprice}€", "#{'%.2f' %ip.total}€"]], :column_widths =>[d,q,u,t]) do
             #ip.total
             row(0).style(:padding => [paddingh,paddingv])
             column(1..3).style(:align => :right)
          end
          @sum += ip.total
       end
      
       #empty placeholder
       pdf.table([['','',""]], :column_widths =>[d+q,u,t])do
          row(0).height = 5
          row(0).style(:padding => [paddingh,paddingv])
       end
        
       #invoice positions data WITHOUT unitprice
      else
        #pdf.table([['PosNr:', 'Beschreibung:', 'Menge:', 'Total:']],  :column_widths =>[p,d,q,t])
        pdf.table([['Leistung(en)', 'Menge', 'Total']],  :column_widths =>[d+u,q,t]) do
          row(0).style(:background_color => 'dddddd', :font_style => :bold, :padding => [paddingh,paddingv])
          column(1..2).style(:align => :right)
        end     
      
        @invoice_posses.each do |ip|
          poscount += 1
          #pdf.table([["#{ip.invoiceposnr}", "#{ip.description}", "#{ip.qty}","#{ip.unitprice}", "#{ip.total}"]], :column_widths =>[p,d,q,u,t]) do
          pdf.table([["#{ip.description}", "#{'%.1f' %ip.qty}", "#{'%.2f' %ip.total}€"]], :column_widths =>[d+u,q,t]) do
             #ip.total
             row(0).style(:padding => [paddingh,paddingv])
             column(1..2).style(:align => :right)
          end
          @sum += ip.total
        end
        
        #empty placeholder
        pdf.table([['','',""]], :column_widths =>[d+u,q,t])do
           row(0).height = 5
           row(0).style(:padding => [paddingh,paddingv])
        end 
      
      end
            
      #puts "######################## #{@sum}"
      #sum
      #"#{'%.2f' % number}"
      pdf.table([['Nettobetrag','',"#{'%.2f' %@sum}€"]], :column_widths =>[d+q,u,t])do
        row(0).style(:align => :right, :padding => [paddingh,paddingv])
      end
  
      @invoice_posses.each do |ip|
         if ip.mwst == mehrwertsteuergering
            @if7 = 1
            @sum7 += ip.total
            @mwst7 =@sum7/100*mehrwertsteuergering
         end
      end     
     
      if @if7 == 1
        pdf.table([["Mehrwertsteuer (  #{mehrwertsteuergering},00 %)",'',"#{'%.2f' %@mwst7}€"]], :column_widths =>[d+q,u,t])do
           row(0).style(:align => :right, :padding => [paddingh,paddingv])
        end
      end

      @invoice_posses.each do |ip|
         if ip.mwst == mehrwertsteuerhoch  
            @if19 = 1
            @sum19 +=ip.total        
            @mwst19 =@sum19/100*mehrwertsteuerhoch
         end
      end
      
      if @if19 == 1
         pdf.table([["Mehrwertsteuer (#{mehrwertsteuerhoch},00 %)",'',"#{'%.2f' %@mwst19}€"]], :column_widths =>[d+q,u,t])do
            row(0).style(:align => :right, :padding => [paddingh,paddingv])
         end
      end
  
      @sumbrut = @mwst19+@sum+@mwst7
      pdf.table([["Bruttobetrag",'',"#{'%.2f' %@sumbrut}€"]], :column_widths =>[d+q,u,t])do
         row(0).style(:align => :right, :padding => [paddingh,paddingv])
      end
    poscount
  end
  
  def sendsave           
      send_file "#{@fp}#{@invoice.invoicenr}_#{@timestamp}.pdf ", :type => "application/pdf"
      @filepath = FilePath.new
      @filepath.path = "#{@fp}#{@invoice.invoicenr}_#{@timestamp}.pdf"
      @filepath.invoice_id = @invoice.id
      @filepath.save
  end
  
  
  def download
    filepathid = params[:id]
    @filepath = FilePath.find_by_id(filepathid)
    send_file "#{@filepath.path}", :type=>"application/pdf" 
  end
  
end
