import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("Received data:", data);

    const notificationsContainer = document.getElementById("notifications");
    if (notificationsContainer) {
      const notificationHtml = `
        <div class="notification">
          <strong>${data}</strong>: ${data} (Due: ${data})
        </div>
      `;
      notificationsContainer.innerHTML += notificationHtml;
    }
  }
});
