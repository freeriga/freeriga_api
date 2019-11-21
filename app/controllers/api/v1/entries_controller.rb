# frozen_string_literal: true

module Api::V1
  class Api::V1::EntriesController < ApiController
    def index
      @entries = Entry.includes(:item).order(updated_at: :desc).page(params[:page]).per(20)
      render json: EntrySerializer.new(@entries, includes: [:item]).serialized_json, status: 200
    end

    def show
      @entry = Entry.includes(:item).find(params[:id])
      render json: EntrySerializer.new(@entry, includes: [:item]).serialized_json, status: 200
    end
    
  end
end