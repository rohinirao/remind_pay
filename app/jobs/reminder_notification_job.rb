class ReminderNotificationJob < ApplicationJob
  queue_as :default

  def perform(reminder_id)
    reminder = Reminder.find_by(id: reminder_id)
    return unless reminder&.due?

    ActionCable.server.broadcast(
      "notifications",
      { title: reminder.title,
      message: "Your reminder for #{reminder.title} is due for #{reminder.price}",
      trigger_at: reminder.trigger_at.strftime("%Y-%m-%d %H:%M") }
    )

    case reminder.recurrence
    when "Daily"
      reminder.update(trigger_at: reminder.trigger_at + 1.day)
    when "Weekly"
      reminder.update(trigger_at: reminder.trigger_at + 1.week)
    when "Monthly"
      reminder.update(trigger_at: reminder.trigger_at + 1.month)
    end
    # place holder for other buissness logic to send mail or something
  end
end
