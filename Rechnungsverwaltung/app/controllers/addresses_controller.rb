class AddressesController < ApplicationController

  def index
    @addresses = Address.all
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(params[:address])
    
    respond_to do |format|
      if @address.save
        format.html { redirect_to(@address, :notice => 'Adresse erstellt') }
      else
        format.html { render :action => "new" }
      end
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