require 'net/http'
require 'uri'
require 'json'
require "base64"

# 環境変数：home_controller.rb
keycode_s = ENV['KEYCODE']
modified_url_s = ENV['FILE_ID'] 


response = Net::HTTP.post(
    # 自分の製作したAPPのURL
    URI('https://script.google.com/macros/s/AKfycbzo7SHpPmcN0wcaicmINs2o5nesndA0hoNKSLSwPao98MrUFqY-mcxnHm3u5M1IF526/exec'),
    
    #GASAPIのキーコードとダウンロードするファイルのIDを定義
    {keycode:keycode_s , id:modified_url_s}.to_json,    
    'Content-Type' => 'application/json'
)

puts modified_url_s + ":add"
puts keycode_s +":add"

case response
when Net::HTTPSuccess
    # 何もしない
when Net::HTTPRedirection
    puts 'redirect!'

    # リダイレクト対応
    response = Net::HTTP.get_response(URI.parse(response['location']))
    case response
    when Net::HTTPSuccess
        # 何もしない
    else
        response = nil
    end
else
    response = nil
end

if response.nil?
    puts 'ERROR!Response is nil'
    return
end

puts "Response Body: #{response.body}"
# {message:'succeeded', base64:'...'}
params = JSON.parse(response.body);

if params['base64'].nil?
    puts 'ERROR: base64 is nil'
    return
end

puts params['message']


# ファイルに保存
download_path = ENV['DOWNLOAD_PATH']
File.open(download_path, "wb") do |file|
     file.write(Base64.decode64(params['base64']))
end





JavaScriptでテキストを複数行に表示する場合、
`\n` を使って改行を挿入できます。
しかし、HTMLではこの `\n` は無視されるので、
代わりに `<br>` タグを使用します。

以下のように `innerHTML` を使用して、
テキストと `<br>` タグを組み合わせることで望む形にできます。

```javascript
notification.innerHTML = '現在表示しているPDFファイルは <br>' + data.message.replace(/display/g, '<br>display');
```

この例では、`data.message` の中の "display" が新しい行で始まるように `<br>` タグを追加しています。
この結果、通知は以下のように表示されるはずです。

```
現在表示しているPDFファイルは
display1:aaa
display2:aaa
```

`innerHTML` を使っているので、HTMLタグを使ってテキストを整形できます。
ただし、ユーザーからの入力をそのまま `innerHTML` に挿入する際は、
XSS（クロスサイトスクリプティング）のリスクがあるため注意が必要です。
この例では `data.message` が信頼できる情報であると仮定しています。

このエラーメッセージは、Railsアプリケーションが一時ファイルをリネームしようとしたときに「Permission denied（アクセス許可がありません）」というエラーが発生したことを示しています。
具体的には、`sprockets`（アセットパイプラインを担当するライブラリ）が一時キャッシュファイルを作成またはリネームしようとしたところ、このエラーが発生しました。

### 修正方法

1. **ファイルパーミッションの確認**: 一時キャッシュファイルが保存されるディレクトリ（このケースでは `C:/Users/s_k_t/pusher_test1010_app/tmp/cache/assets/sprockets/`）のパーミッションを確認してください。
必要ならば、書き込み可能に設定してください。
   
2. **キャッシュのクリア**: 一時キャッシュを手動で削除してみてください。`tmp` フォルダ内のキャッシュを全て削除することもあります。

   ```
   # ターミナルでRailsプロジェクトのルートディレクトリに移動して
   rm -rf tmp/cache
   ```

3. **サーバーの再起動**: キャッシュをクリアした後、Railsサーバーを再起動してください。

   ```
   # ターミナルで
   rails s
   ```

4. **Railsアプリケーションの実行ユーザー**: アプリケーションが実行されているユーザーが、一時ファイルを作成/削除するための十分なパーミッションを持っていることを確認してください。


はい、自動で再接続や再試行を行うようにプログラムを設計することは可能です。具体的な実装はプログラムの言語や使用しているライブラリによりますが、一般的なアプローチは以下のようになります。

### Ruby on Rails（サーバーサイド）

サーバーサイドでエラーが発生した場合、例外処理を用いて再試行を行うことができます。

```ruby
begin
  # エラーが発生する可能性があるコード
rescue => e
  puts "エラーが発生しました: #{e.message}"
  # 再試行するロジック
  retry if some_condition
end
```

### JavaScript（クライアントサイド）

JavaScriptでは、`fetch`や`XMLHttpRequest`でエラーが発生した場合、再試行を行うことができます。

```javascript
let retries = 3;

function fetchData() {
  fetch("/some/api/endpoint")
    .then(response => response.json())
    .then(data => {
      // 何らかの処理
    })
    .catch(error => {
      if (retries > 0) {
        console.log(`再試行します。残り試行回数: ${retries}`);
        retries--;
        fetchData();
      } else {
        console.log("エラーが発生しました:", error);
      }
    });
}

fetchData();
```

### 自動でページを再読み込み

JavaScriptを使用して、特定のエラーが発生した場合にページ全体を再読み込みすることもできます。

```javascript
window.location.reload();
```

ただし、この方法はユーザーエクスペリエンスに悪影響を与える可能性があるため、注意が必要です。

これらは基本的なアプローチですが、特定の要件や制約に応じてカスタマイズすることができます。自動再試行にはタイムアウトや上限回数など、さまざまな制約を設けることが一般的です。