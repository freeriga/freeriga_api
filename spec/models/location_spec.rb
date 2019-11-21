require 'rails_helper'

RSpec.describe Location, type: :model do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:quarter) }
    it { is_expected.to validate_presence_of(:name) }
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:location).save).to be true
  end

end
