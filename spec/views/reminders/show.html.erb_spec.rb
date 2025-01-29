require 'rails_helper'

RSpec.describe "reminders/show", type: :view do
  before(:each) do
    assign(:reminder, FactoryBot.create(:reminder))
    assign(:due_notifications, [])
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Test description/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Currency/)
    expect(rendered).to match(/Recurrence/)
  end
end
