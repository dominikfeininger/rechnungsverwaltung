class CustomerAttributesController < ApplicationController

  def index
    @cutomerattributes = CustomerAttribute.all
  end

  def new
    @cutomerattribute = CustomerAttribute.new
  end

  def create
    @cutomerattribute = CustomerAttribute.new(params[:customerattibute])

      if @cutomerattribute.save
         redirect_to(@cutomerattribute, :notice => 'Kundenattribut erstellt') 
      else
         render :action => "new" 
      end
  end

  def show
    @cutomerattribute = CustomerAttribute.find(params[:id])
  end
  
  def destroy
    @cutomerattribute = CustomerAttribute.find(params[:id])
    @cutomerattribute.destroy
  end
end