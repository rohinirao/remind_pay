require 'rails_helper'

RSpec.describe Reminder, type: :model do
  describe 'validations' do
    subject { FactoryBot.create(:reminder) }

    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(250) }
    it { should allow_value('Valid Title 123').for(:title) }
    it { should_not allow_value('Invalid@Title!').for(:title).with_message('only allows letters, numbers and spaces') }

    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0.01).is_less_than(1000000).with_message('must be between $0.01 and $999,999.99') }

    it { should validate_presence_of(:trigger_at) }
    it { should validate_presence_of(:currency) }
    it { should validate_inclusion_of(:recurrence).in_array([ 'Daily', 'Weekly', 'Monthly', '-' ]) }

    context 'trigger_at validation' do
      it 'is invalid if trigger_at is in the past' do
        reminder = described_class.new(title: "tittle", description: "test description", price: 12.50, currency: "euro", trigger_at: 1.day.ago)
        expect(reminder).not_to be_valid
        expect(reminder.errors[:trigger_at].present?).to eq(true)
      end

      it 'is valid if trigger_at is in the future' do
        reminder = FactoryBot.create(:reminder, trigger_at: 1.day.from_now)
        expect(reminder).to be_valid
      end
    end
  end

  describe 'scopes' do
    describe '.by_latest' do
      it 'returns reminders ordered by trigger_at in ascending order' do
        reminder1 = FactoryBot.create(:reminder, trigger_at: 1.day.from_now)
        reminder2 = FactoryBot.create(:reminder, trigger_at: 2.days.from_now)
        reminder3 = FactoryBot.create(:reminder, trigger_at: 3.days.from_now)

        expect(Reminder.by_latest).to eq([ reminder1, reminder2, reminder3 ])
      end
    end
  end

  describe '#due?' do
    it 'returns true if trigger_at is in the past or now' do
      reminder = FactoryBot.create(:reminder, trigger_at: Time.current)
      expect(reminder.due?).to be true
    end

    it 'returns false if trigger_at is in the future' do
      reminder = FactoryBot.create(:reminder, trigger_at: 1.day.from_now)
      expect(reminder.due?).to be false
    end
  end

  describe 'callbacks' do
    xit 'schedules a notification job after commit' do
      reminder = FactoryBot.create(:reminder)
      reminder.save
      expect(ReminderNotificationJob).to receive(:set).with(wait_until: reminder.trigger_at).and_call_original
      expect(ReminderNotificationJob).to receive(:perform_later).with(reminder.id)
    end
  end
end
