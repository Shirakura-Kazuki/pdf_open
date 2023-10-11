document.addEventListener("DOMContentLoaded", function() {
    var pusher = new Pusher('32f2640be6b94e4b6afe', {
      cluster: 'ap3'
    });
  
    var channel = pusher.subscribe('my-channel');
    
    //my-event:トリガー関数
    channel.bind('my-event', function(data) {
      alert('Received my-event with message: ' + data.message);
    });
  
    // document.getElementById("send-notification").addEventListener("click", function() {
    //   fetch('/send_notification', {
    //     method: 'POST',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    //     }
    //   });
    // });

    // 動作test用：プッシュ通知定義

    document.getElementById("send-notification").addEventListener("click", function() {
        fetch('/send_pdf', {    //routes.rb定義
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
          }
        });
      });
  });
  