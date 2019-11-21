# frozen_string_literal: true

require 'swagger_helper'

describe 'Quarters API', type: :request do

  path '/v1/quarters' do
    let(:client) { @auth_headers['client'] }
    let('Access-Token') { @auth_headers['access-token'] }
    let(:uid) { @auth_headers['uid'] }

    get 'Return all quarters' do
      tags 'Quarters'
      produces 'application/json'
      description 'Returns all quarters.'
      security [client: [], 'Access-Token': [], uid: []]
      
      before do
        create_list(:quarter, 3)
        terminal = FactoryBot.create(:terminal)
        @auth_headers = terminal.create_new_auth_token
      end

      after do |example|
        example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 200, 'Quarters successfully returned' do
        run_test!
      end

    end
  end
end



