# frozen_string_literal: true

require 'swagger_helper'

describe 'Tasks API', type: :request do

  path '/v1/locations/{location_id}/tasks' do
    let(:client) { @auth_headers['client'] }
    let('Access-Token') { @auth_headers['access-token'] }
    let(:uid) { @auth_headers['uid'] }
    parameter name: :location_id, in: :path, type: :number
    let(:location) { FactoryBot.create(:location) }
    let(:location_id) { location.id }


    post 'Create a task' do
      tags 'Locations', 'Tasks'
      produces 'application/json'
      consumes 'application/json'
      description 'Create a task for a location'
      security [client: [], 'Access-Token': [], uid: []]
      parameter name: :task, in: :body, schema: { '$ref' => '#/definitions/task_object' }

      before do
        @user = FactoryBot.create(:user)
        @auth_headers = @user.create_new_auth_token
      end

      after do |example|
        example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 201, 'Task successfully created' do
        let(:task) { { user_id: @user.id, username: 'Jacko Fuckhead', user_location_id: location.id,  translations_attributes: [{ locale: 'en', summary: 'I like cheese. This is a terrible idea. I hate everything.'}], colour: '#342342', status: 2} } 
        run_test!
      end

      response 401, 'Not authenticated' do
        let(:task) { { user_id: @user.id, username: 'Jacko Fuckhead', user_location_id: location.id,  translations_attributes: [{ locale: 'en', summary: 'I like cheese. This is a terrible idea. I hate everything.'}], colour: '#342342', status: 2} }         
        let(:uid) { '' }
        run_test!
      end
    end
  end

  path '/v1/tasks' do
    let(:client) { @auth_headers['client'] }
    let('Access-Token') { @auth_headers['access-token'] }
    let(:uid) { @auth_headers['uid'] }


    get 'Return all tasks' do
      tags 'Quarters', 'Tasks'
      produces 'application/json'
      description 'Return all tasks overall'
      security [client: [], 'Access-Token': [], uid: []]

      before do
        create_list(:task, 20)
        terminal = FactoryBot.create(:terminal)
        @auth_headers = terminal.create_new_auth_token
      end

      after do |example|
        example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 200, 'Tasks successfully returned' do
        run_test!
      end
    end
  end

  path '/v1/quarters/{quarter_id}/tasks' do
    let(:client) { @auth_headers['client'] }
    let('Access-Token') { @auth_headers['access-token'] }
    let(:uid) { @auth_headers['uid'] }

    get 'Return all tasks for a quarter' do
      tags 'Quarters', 'Tasks'
      produces 'application/json'
      description 'Returns all tasks for a quarter'
      security [client: [], 'Access-Token': [], uid: []]
      parameter name: :quarter_id, in: :path, type: :number
      let(:quarter) { FactoryBot.create(:quarter) }
      let(:quarter_id) { quarter.id }
      security [client: [], 'Access-Token': [], uid: []]
      
      before do
        l1 = FactoryBot.create(:location, quarter: quarter)
        l2 = FactoryBot.create(:location, quarter: quarter)
        3.times do
          FactoryBot.create(:task, location: l1)
        end
        3.times do
          FactoryBot.create(:task, location: l2)
        end
        terminal = FactoryBot.create(:terminal)
        @auth_headers = terminal.create_new_auth_token
      end

      after do |example|
        example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 200, 'Tasks successfully returned' do
        run_test!
      end

      response 404, 'Quarter not found' do
        let(:quarter_id) { quarter.id + 32 }
        run_test!
      end
    end
  end
end



