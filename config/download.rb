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