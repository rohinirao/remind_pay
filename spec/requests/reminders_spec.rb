require 'rails_helper'

RSpec.describe "/reminders", type: :request do
  let!(:reminder) { FactoryBot.create(:reminder) } # FactoryBot-generated reminder
  let(:valid_attributes) do
    {
      title: "Test Reminder",
      description: "A test reminder description",
      trigger_at: 1.day.from_now,
      price: 10.0,
      currency: "USD",
      recurrence: "Daily"
    }
  end

  let(:invalid_attributes) do
    {
      title: "",
      description: "",
      trigger_at: 1.day.ago,
      price: -10.0,
      currency: nil,
      recurrence: "Invalid"
    }
  end

  describe "GET /index" do
    it "renders a successful response" do
      get reminders_path
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get reminder_path(reminder)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_reminder_path
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_reminder_path(reminder)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Reminder" do
        expect {
          post reminders_path, params: { reminder: valid_attributes }
        }.to change(Reminder, :count).by(1)
      end

      it "redirects to the created reminder" do
        post reminders_path, params: { reminder: valid_attributes }
        expect(response).to redirect_to(reminder_path(Reminder.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Reminder" do
        expect {
          post reminders_path, params: { reminder: invalid_attributes }
        }.not_to change(Reminder, :count)
      end

      it "renders an unprocessable entity response" do
        post reminders_path, params: { reminder: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        {
          title: "Updated Reminder Title",
          description: "Updated description"
        }
      end

      it "updates the requested reminder" do
        patch reminder_path(reminder), params: { reminder: new_attributes }
        reminder.reload
        expect(reminder.title).to eq("Updated Reminder Title")
        expect(reminder.description).to eq("Updated description")
      end

      it "redirects to the reminder" do
        patch reminder_path(reminder), params: { reminder: new_attributes }
        expect(response).to redirect_to(reminder_path(reminder))
      end
    end

    context "with invalid parameters" do
      it "renders an unprocessable entity response" do
        patch reminder_path(reminder), params: { reminder: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested reminder" do
      expect {
        delete reminder_path(reminder)
      }.to change(Reminder, :count).by(-1)
    end

    it "redirects to the reminders list" do
      delete reminder_path(reminder)
      expect(response).to redirect_to(reminders_path)
    end
  end
end
