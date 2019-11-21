# frozen_string_literal: true

require 'swagger_helper'

describe 'Comments API', type: :request do
  path '/v1/entries/{entry_id}/comments' do
    let(:client) { @auth_headers['client'] }
    let('Access-Token') { @auth_headers['access-token'] }
    let(:uid) { @auth_headers['uid'] }
    parameter name: :entry_id, in: :path, type: :number

    post 'Create a comment on any entry and the parent item' do
      tags 'Entries', 'Comments'
      consumes 'application/json'
      produces 'application/json'
      description 'Create a new comment on a entry. Automatically associates comment to whatever parent item is.'
      parameter name: :comment, in: :body, schema: { '$ref' => '#/definitions/comment_object'}
      security [client: [], 'Access-Token': [], uid: []]
      let(:task) { FactoryBot.create(:task) }
      let(:entry_id) { task.entry.id }
      let(:comment) { { username: 'Jacko Fuckhead', translations_attributes: [{ locale: 'en', body: 'I like cheese. This is a terrible idea. I hate everything.'}], colour: '#342342', location_id: task.location_id } } 

      before do
        terminal = FactoryBot.create(:terminal)
        @auth_headers = terminal.create_new_auth_token
      end


      after do |example|
        example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 201, 'Comment succesfully created' do
        run_test!
      end

      response 401, 'Not authenticated' do
        let(:uid) { '' }
        run_test!
      end

      response 404, 'Not found' do
        let(:entry_id) { 2342352 }
        run_test!
      end
    end
  end

  path '/v1/tasks/{task_id}/comments' do
    let(:client) { @auth_headers['client'] }
    let('Access-Token') { @auth_headers['access-token'] }
    let(:uid) { @auth_headers['uid'] }

    parameter name: :task_id, in: :path, type: :number

    post 'Create a comment' do
      tags 'Tasks', 'Comments'
      consumes 'application/json'
      produces 'application/json'
      description 'Create a new comment on a task'
      security [client: [], 'Access-Token': [], uid: []]
      parameter name: :comment, in: :body, schema: { '$ref' => '#/definitions/comment_object'}

      let(:task) { FactoryBot.create(:task) }
      let(:task_id) { task.id }
      let(:comment) { { username: 'Jacko Fuckhead', translations_attributes: [{ "locale": 'en', 'body': 'I like cheese. This is a terrible idea. I hate everything.'}], colour: '#342342', location_id: task.location_id } } 

      before do
        terminal = FactoryBot.create(:terminal)
        @auth_headers = terminal.create_new_auth_token
      end

      after do |example|
        example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 201, 'Comment succesfully created' do
        run_test!
      end

      response 401, 'Not authenticated' do
        let(:uid) { '' }
        run_test!
      end

      response 404, 'Not found' do
        let(:task_id) { 2342352 }
        run_test!
      end

      response 422, 'Not processible' do
        let(:comment) { { username: 'Jacko Fuckhead', colour: '#342342', location_id: task.location_id } }
        run_test!
      end
    end
  end
end