require 'rails_helper'

RSpec.describe Reminder, type: :model do
  include ActiveJob::TestHelper
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
    it { should validate_presence_of(:recurrence) }
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
    describe 'by_oldest' do
      it 'returns reminders ordered by trigger_at in ascending order' do
        reminder1 = FactoryBot.create(:reminder, trigger_at: 1.day.from_now)
        reminder2 = FactoryBot.create(:reminder, trigger_at: 2.days.from_now)
        reminder3 = FactoryBot.create(:reminder, trigger_at: 3.days.from_now)

        expect(Reminder.by_oldest).to eq([ reminder1, reminder2, reminder3 ])
      end
    end

    describe ".get_dues" do
      let!(:due_reminder) { FactoryBot.create(:reminder, trigger_at: Time.current, recurrence: "-") }
      let!(:future_reminder) { FactoryBot.create(:reminder, trigger_at: Time.current + 1.day, recurrence: "-") }
      let!(:daily_reminder) { FactoryBot.create(:reminder, trigger_at: Time.current, recurrence: "Daily") }
      let!(:weekly_reminder) { FactoryBot.create(:reminder, trigger_at: 1.week.from_now.beginning_of_day + 1.hour, recurrence: "Weekly") }
      let!(:monthly_reminder) { FactoryBot.create(:reminder, trigger_at: 1.month.from_now.change(hour: Time.current.hour), recurrence: "Monthly") }

      it "includes due reminders for today" do
        expect(Reminder.get_dues).to include(due_reminder)
      end

      it "does not include future reminders" do
        expect(Reminder.get_dues).not_to include(future_reminder)
      end

      it "includes daily reminders if the time has passed" do
        expect(Reminder.get_dues).to include(daily_reminder)
      end

      it "includes weekly reminders if set for today and time has passed" do
        expect(Reminder.get_dues).to include(weekly_reminder)
      end

      it "includes monthly reminders if set for today and time has passed" do
        expect(Reminder.get_dues).to include(monthly_reminder)
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
    it 'schedules a notification job after commit' do
      reminder = Reminder.create(title: "test", trigger_at: Time.current, price: 56, currency: "Euro", recurrence: '-')
      expect(ReminderNotificationJob).to have_been_enqueued.with(reminder.id)
      reminder.save
    end
  end
end
