# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Terminal, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:location) }
  end

  it 'has a valid factory' do
    t = FactoryBot.build(:terminal, password: 'rand23423om')
    expect(t.save).to be true
  end

  it 'is invalid without a location' do
    expect(FactoryBot.build(:terminal, location: nil).save).to be false
  end

  it 'is invalid without a name' do
    expect(FactoryBot.build(:terminal, name: nil).save).to be false
  end

  it 'is invalid without a unique email' do
    terminal = FactoryBot.create(:terminal, password: 'random23423')
    expect(FactoryBot.build(:terminal, email: terminal.email).save).to be false
  end

  it 'is invalid without a unique location' do
    terminal = FactoryBot.create(:terminal, password: 'random23423')
    expect(FactoryBot.build(:terminal, location: terminal.location).save).to be false
  end

  it 'is database authenticable' do
    terminal = Terminal.create(
       email: 'test@example.com', 
      password: 'password123',
      password_confirmation: 'password123'
    )
    expect(terminal.valid_password?('password123')).to be_truthy
  end
end
