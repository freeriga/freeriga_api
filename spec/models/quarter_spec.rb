require 'rails_helper'

RSpec.describe Quarter, type: :model do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:address) }
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:quarter).save).to be true
  end

end
