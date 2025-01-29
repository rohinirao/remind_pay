class ReminderNotificationJob < ApplicationJob
  queue_as :default

  def perform(reminder_id)
    reminder = Reminder.find_by(id: reminder_id)
    return unless reminder&.due?

    ActionCable.server.broadcast(
      "notifications",
      { title: reminder.title,
      message: "Your reminder for #{reminder.title} is due!",
      trigger_at: reminder.trigger_at.strftime("%Y-%m-%d %H:%M") }
    )

    # Handle recurrence
    if reminder.recurrence.present?
      case reminder.recurrence
      when "daily"
        reminder.update(trigger_at: reminder.trigger_at + 1.day)
      when "weekly"
        reminder.update(trigger_at: reminder.trigger_at + 1.week)
      when "monthly"
        reminder.update(trigger_at: reminder.trigger_at + 1.month)
      end

      reminder.schedule_notification
    end
  end
end
