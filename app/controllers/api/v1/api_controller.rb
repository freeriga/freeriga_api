# frozen_string_literal: true

module Api::V1
  # This is the parent API controller which the individual APIs inherit things from
  class ApiController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken

    # skip_load_and_authorize_resource only: :home
    # load_and_authorize_resource except: :home
    before_action :authenticate_terminal!

    def home
      render json: { name: 'Free Riga API', environment: Rails.env.to_s }, status: 200
      #, release: Rails.env.development? ? `git describe`.gsub(/\n/, '').gsub(/^v/, '') : '',
        # gitref: Rails.env.development? ? `git rev-parse HEAD`.gsub(/\n/, '') : `cat REVISION`.gsub(/\n/, '') , migration:  ActiveRecord::Migrator.current_version }
    end
  end
end
