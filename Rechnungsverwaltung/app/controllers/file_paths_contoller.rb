class FilePathsController < ApplicationController

  def index
    @filepaths = FilePath.all
  end

  def new
    @filepath = FilePath.new
  end

  def create
    @filepath = FilePath.new(params[:filepath])

      if @filepath.save
         redirect_to(@filepath, :notice => 'pdf erstellt') 
      else
         render :action => "new" 
      end
  end

  def show
    @filepath = FilePath.find(params[:id])
  end
  
  def destroy
    @filepath = FilePath.find(params[:id])
    @filepath.destroy
  end
end