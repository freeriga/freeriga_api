require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:colour) }
    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:user_location) }
    it { is_expected.to validate_presence_of(:status) }
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:task, :with_user).save).to be true
  end

  it 'must have a name in at least one language' do
    td = Task.new(location: FactoryBot.create(:location), username: 'foo', colour: 'foo', status: 0, summary: nil)
    expect(td.save).to be false
  end

end
