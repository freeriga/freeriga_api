require 'rails_helper'

RSpec.describe ApplicationCable::Channel, type: :channel do

  it 'subscribes' do
    subscribe
    expect(subscription).not_to be_rejected
    expect(subscription).to be_confirmed
    
  end

  # it 'subscribes to a stream when user is authenticated' do
  #   quarter = FactoryBot.create(:quarter)
  #   stub_connection quarter: quarter
  #   subscribe
  #   expect(subscription).to be_confirmed
  #   expect(subscription).to have_stream_for(quarter)
  # end
end

