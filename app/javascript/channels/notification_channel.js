import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    console.log("connected")
  },

  disconnected() {
    console.log("disconnected")
  },

  received(data) {
    console.log(" data:", data.message);
    const notificationsContainer = document.getElementById("notifications");
    if (notificationsContainer) {
      const notificationHtml = `<div class="notification"> <strong>${data.message} </div>`;
      notificationsContainer.innerHTML += notificationHtml;
    }
  }
});
