document.addEventListener("DOMContentLoaded", function() {
  var pusher = new Pusher('32f2640be6b94e4b6afe', {
    cluster: 'ap3'
  });

  var channel = pusher.subscribe('my-channel');

  channel.bind('my-event', function(data) {
    alert('Received my-event with message: ' + data.message);
  });

  // my-event: Custom Trigger Function
  channel.bind('my-event', function(data) {
    // Create and display the notification
    var notification = document.createElement('div');
    notification.innerText = 'Received my-event with message: ' + data.message;
    notification.style.position = 'fixed';
    notification.style.top = '50%';
    notification.style.left = '50%';
    notification.style.transform = 'translate(-50%, -50%)';
    notification.style.backgroundColor = '#ffffff';
    notification.style.border = '1px solid #ccc';
    notification.style.padding = '15px';
    notification.style.width = '200px';
    notification.style.height = '100px';  // Changed from 300px to 100px
    notification.style.zIndex = '1000';
    document.body.appendChild(notification);

    // Remove the notification after 3 seconds
    setTimeout(function() {
      document.body.removeChild(notification);
    }, 3000);
  });
});


  