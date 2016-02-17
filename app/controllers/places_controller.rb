class PlacesController < ApplicationController
  def index
  end

  def show
    places = BeermappingApi.places_in(session[:city])
    @place = get_place(places)   
    render :show
  end

  def search
    @places = BeermappingApi.places_in(params[:city])   
    
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:city] = params[:city]
      render :index
    end
  end

  private
  
  def get_place(places)
    places.map do |place|
      if place.id == params[:id]
        return place
      end
    end
  end
end
