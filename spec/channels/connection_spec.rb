require 'pp'
require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  it 'successfully connects' do
    connect '/cable'
    expect(connection).not_to be nil
  end

  # it "rejects connection" do
  #   expect { connect "/cable" }.to have_rejected_connection
  # end
end
