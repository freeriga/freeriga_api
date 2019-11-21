# frozen_string_literal: true

require 'rails_helper'
require 'pp'

RSpec.describe 'Terminal authentication', type: :request do
  let(:json_headers) { { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' } }
  
  before(:all) do
    @terminal = FactoryBot.create(:terminal)
  end

  describe 'POST /terminal_auth/sign_in' do
    context 'should be able to sign in' do
      before do
        post '/terminal_auth/sign_in', params: { login: @terminal.email, password: @terminal.password }
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'has the access token and uid in the headers' do
        expect(response.headers['access-token']).not_to be_empty
        expect(response.header['uid']).to eq(@terminal.email)
      end
    end
  end
end
