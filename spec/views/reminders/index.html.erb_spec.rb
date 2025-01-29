require 'rails_helper'

RSpec.describe "reminders/index", type: :view do
  before(:each) do
    assign(:reminders, [ FactoryBot.create(:reminder, trigger_at: 1.day.from_now), FactoryBot.create(:reminder, trigger_at: 2.day.from_now) ])
    assign(:due_notifications, [])
  end

  it "renders a list of reminders" do
    render
    cell_selector = 'td'
    assert_select cell_selector, text: Regexp.new("Test123".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Test description".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Euro".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Daily".to_s), count: 2
  end
end
