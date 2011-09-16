class AddressesController < ApplicationController

  def index
    @addresses = Address.all
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(params[:address])

      if @address.save
         redirect_to(@address, :notice => 'Adresse erstellt') 
      else
         render :action => "new" 
      end
  end

  def show
    @address = Address.find(params[:id])
  end
  
  def destroy
    @address = Address.find(params[:id])
    @address.destroy
  end
end