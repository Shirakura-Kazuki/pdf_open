document.addEventListener("DOMContentLoaded", function() {
  var pusher = new Pusher('32f2640be6b94e4b6afe', {
    cluster: 'ap3'
  });

  var channel = pusher.subscribe('my-channel');


  // 前回使用コード：alert()呼び出し→ブラウザ固定のダイアログ（通知テンプレ）が送信される
  // channel.bind('my-event', function(data) {
  //   alert('Received my-event with message: ' + data.message);
  // });

  // my-event（トリガー）：発生時の関数
  channel.bind('my-event', function(data) {

    // notification:通知ドキュメント定義
    // 新しい`<div>`要素を作成
    var notification = document.createElement('div');
    // <div>`要素に表示するテキストを設定:通知のスタイル変更
    
    // notification.innerText = 'ファイルの更新を行います：' + data.message;
    notification.innerText = 'しばらくお待ちください' + data.message;
    notification.style.position = 'fixed';
    notification.style.backgroundposition = 'righttops';
    notification.style.top = '10%';
    notification.style.left = '50%';
    notification.style.transform = 'translate(-50%, -50%)';
    notification.style.backgroundColor = '#AFEEEE';
    notification.style.border = '1px solid #ccc';
    notification.style.color = '#000000'
    notification.style.border = '1px solid #ccc';
    notification.style.borderRadius = '12px';  // 角を丸く
    notification.style.padding = '15px 30px';  // 内側の余白（上下15px、左右30px）
    notification.style.width = 'auto';  // 横幅は自動
    notification.style.height = 'auto';  // 縦幅は自動
    notification.style.border = "outset 3px #808080";
    notification.style.zIndex = '1000';
    notification.style.textAlign = 'center';  // テキストを中央寄せに
    document.body.appendChild(notification);

    // 3秒後に通知を閉じる
    setTimeout(function() {
      document.body.removeChild(notification);
    }, 3000);
  });
});


  