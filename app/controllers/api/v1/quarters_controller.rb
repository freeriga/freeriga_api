# frozen_string_literal: true
module Api::V1
  class Api::V1::QuartersController < ApiController
    skip_before_action :authenticate_member!, only: :index

    def index
      render json: QuarterSerializer.new(Quarter.all).serialized_json, status: 200
    end

  end
end