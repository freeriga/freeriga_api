# frozen_string_literal: true

require 'swagger_helper'

describe 'Locations API', type: :request do

  path '/v1/locations' do
    let(:client) { @auth_headers['client'] }
    let('Access-Token') { @auth_headers['access-token'] }
    let(:uid) { @auth_headers['uid'] }

    get 'Return all locations ' do
      tags 'Quarters', 'Locations'
      produces 'application/json'
      description 'Returns every location in the system'
      security [client: [], 'Access-Token': [], uid: []]

      before do
        create_list(:location, 10)
        terminal = FactoryBot.create(:terminal)
        @auth_headers = terminal.create_new_auth_token
      end

      after do |example|
        example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 200, 'Locations successfully returned' do
        run_test!
      end
    end
  end

  path '/v1/quarters/{quarter_id}/locations' do
    let(:client) { @auth_headers['client'] }
    let('Access-Token') { @auth_headers['access-token'] }
    let(:uid) { @auth_headers['uid'] }


    post 'Create or retrieve a new location for a quarter' do
      tags 'Quarters', 'Locations'
      consumes 'application/json'
      produces 'application/json'
      security [client: [], 'Access-Token': [], uid: []]
      description 'Submit a new location, will look up existing one if in database'
      parameter name: :quarter_id, in: :path, type: :numeric
      parameter name: :location, in: :body, schema: { '$ref' => '#/definitions/location_object'}
      let(:quarter) { FactoryBot.create(:quarter) }
      let(:quarter_id) { quarter.id }
      let(:location) { { name: 'T38' }}

      before do
        terminal = FactoryBot.create(:terminal)
        @auth_headers = terminal.create_new_auth_token
      end

      after do |example|
        example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 201, 'Created new location' do
        run_test!
      end

      response 200, 'Location already existed for quarter, returns that location' do
        before do
          FactoryBot.create(:location, name: 'T38', quarter: quarter)
        end
        run_test!
      end

      response 404, 'Quarter not found' do
        let(:quarter_id) { quarter.id + 3442 }
        run_test!
      end

      response 422, 'Not processible' do
        let(:location) { { name: '' } }
        run_test!
      end
    end


    get 'Return all locations for a quarter' do
      tags 'Quarters', 'Locations'
      produces 'application/json'
      description 'Returns all quarters for a location'
      security [client: [], 'Access-Token': [], uid: []]
      parameter name: :quarter_id, in: :path, type: :number
      let(:quarter) { FactoryBot.create(:quarter) }
      let(:quarter_id) { quarter.id }

      before do
        3.times do
          FactoryBot.create(:location, quarter: quarter)
        end
        terminal = FactoryBot.create(:terminal)
        @auth_headers = terminal.create_new_auth_token
      end

      after do |example|
        example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 200, 'Locations successfully returned' do
        run_test!
      end

      response 404, 'Quarter not found' do
        let(:quarter_id) { quarter.id + 32 }
        run_test!
      end
    end
  end
end



