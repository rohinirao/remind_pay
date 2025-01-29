class Reminder < ApplicationRecord
  validates :title, presence: true,
                     length: { maximum: 250 },
                     format: { with: /\A[a-zA-Z0-9\s]+\z/,
                              message: "only allows letters, numbers and spaces" }
  validates :price, presence: true,
                              numericality: {
                                greater_than_or_equal_to: 0.01,
                                less_than: 1000000,
                                message: "must be between $0.01 and $999,999.99"
                              }
  validates :trigger_at, :currency, :recurrence, presence: true
  validates :trigger_at, comparison: { greater_than_or_equal_to: Time.current }
  validates :recurrence, inclusion: { in: [ "Daily", "Weekly", "Monthly", "-" ] }

  after_commit :schedule_notification

  scope :by_oldest, -> { order(trigger_at: :asc) }

  scope :get_dues, -> {
    where(
      "(DATE(trigger_at) = '#{Date.current}' AND TO_CHAR(trigger_at, 'HH24:MI') <= TO_CHAR(NOW(), 'HH24:MI')) OR
      (recurrence = 'Daily' AND TO_CHAR(trigger_at, 'HH24:MI') <= TO_CHAR(NOW(), 'HH24:MI')) OR
      (recurrence = 'Weekly' AND DATE(trigger_at) = '#{1.week.from_now.to_date}' AND TO_CHAR(trigger_at, 'HH24:MI') <= TO_CHAR(NOW(), 'HH24:MI')) OR
      (recurrence = 'Monthly' AND DATE(trigger_at) = '#{1.month.from_now.to_date}' AND TO_CHAR(trigger_at, 'HH24:MI') <= TO_CHAR(NOW(), 'HH24:MI'))"
    )
  }


  def due?
    trigger_at <= Time.current
  end

  def schedule_notification
    ReminderNotificationJob.set(wait_until: trigger_at).perform_later(self.id)
  end
end
