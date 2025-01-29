class NotificationChannel < ApplicationCable::Channel
  def subscribed
    # console.log("Connected to Actioncable")
    puts "connected"
    stream_from "notifications"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
