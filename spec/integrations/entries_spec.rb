# frozen_string_literal: true

require 'swagger_helper'

describe 'Entries API', type: :request do

  path '/v1/entries' do
    let(:client) { @auth_headers['client'] }
    let('Access-Token') { @auth_headers['access-token'] }
    let(:uid) { @auth_headers['uid'] }

    get 'Return all entries ' do
      tags 'Entries'
      produces 'application/json'
      description 'Returns every entry in the system'
      security [client: [], 'Access-Token': [], uid: []]

      before do
        create_list(:task, 5)
        create_list(:comment, 4)
        terminal = FactoryBot.create(:terminal)
        @auth_headers = terminal.create_new_auth_token
      end

      after do |example|
        example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 200, 'Entries successfully returned' do
        run_test!
      end
    end
  end
end