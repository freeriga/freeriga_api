require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:colour) }
    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:item) }
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:comment).save).to be true
  end

  it 'must have a body in at least one language' do
    td = Comment.new(location: FactoryBot.create(:location), username: 'foo', colour: 'foo', item: FactoryBot.create(:task), body: nil)
    expect(td.save).to be false
  end

  it 'should create a comment entry if top-level ' do
    comment = FactoryBot.create(:comment, item: FactoryBot.create(:location))
    expect(comment.entry.item).to eq comment
  end

  it 'should allow a comment on a comment ' do
    orig = FactoryBot.create(:comment, item: FactoryBot.create(:location))
    comment = FactoryBot.create(:comment, item: orig)
    expect(comment.item).to eq orig
    expect(comment.entry).to be nil
    expect(comment.item.comments.count).to eq 1
  end

  it 'should allow a comment on a comment without nesting' do
    orig = FactoryBot.create(:comment, item: FactoryBot.create(:location))
    first = FactoryBot.create(:comment, item: orig)
    comment = FactoryBot.create(:comment, item: first)
    expect(comment.item).to eq orig
    expect(comment.entry).to be nil
    expect(first.entry).to be nil
    expect(orig.comments.count).to eq 2
  end
end
