# frozen_string_literal: true
module Api::V1
  class Api::V1::LocationsController < ApiController
    skip_before_action :authenticate_member!, only: :index
    
    def create
      quarter = Quarter.find(params[:quarter_id])
      existing = quarter.locations.where('lower(name) = ?', params[:location][:name].downcase)
      if existing.empty?
        @location = Location.new(location_params)
        @location.quarter = quarter
        if @location.save
          render json: LocationSerializer.new(@location).serialized_json, status: :created
        else
          respond_with_errors(@location)
        end
      else
        render json: LocationSerializer.new(existing.first).serialized_json, status: 200
      end
    end

    def index
      if params[:quarter_id]
        quarter = Quarter.find(params[:quarter_id])
        @locations = quarter.locations
      else
        @locations = Location.all
      end
      render json: LocationSerializer.new(@locations).serialized_json, status: 200
    end

    protected
      
      def location_params
        params.require(:location).permit(:name)
      end

  end
end
