require 'net/http'
require 'uri'
require 'json'
require "base64"

# AHT21B.pdf					1AQpqlhCGrqAwLfwGrgqxQa3zUrkKJJjZ
# AHT25.pdf					    1KdtZuBJhlxBOh25uqcrinL1nLe9DR6mm
# AE-BME280_manu_v1.1.pdf		14k1xYaEQ12HamdnxflP5lmaI0EySonsw
# AM2322_V1.0.pdf				1Ja7axMHt9HGN1MbzksEGOYY-QRGUEYN3
# AE-AMG8833-BO_20210820.pdf    1TR97KJh0AJf1D5xC0ciik2Vy7rbauoi3

#自分用                         1L1WsAs7RwQ0NlTfeR6QcKJb47T8YBZAG  
#                               1dmD5LNIOFQd0gjkLhRXKXEFF1bzraCCF

response = Net::HTTP.post(
    #URI('https://script.google.com/macros/s/AKfycbx03ht4TI8bcMcBFhuR46EMvwImDLrRBgtNQLUGUBdvbUV6SERc7eSWZCz5cZzm9kXbZg/exec'),
    # 自分の製作したAPPのURL
    URI('https://script.google.com/macros/s/AKfycbzo7SHpPmcN0wcaicmINs2o5nesndA0hoNKSLSwPao98MrUFqY-mcxnHm3u5M1IF526/exec'),
    
    #GASAPIのキーコードとダウンロードするファイルのIDを定義
    {keycode:'download_SO1AZAhF9C1o7kaB52CK', id:'1dmD5LNIOFQd0gjkLhRXKXEFF1bzraCCF'}.to_json,
    'Content-Type' => 'application/json'
)
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
    puts 'ERROR!'
    return
end

# {message:'succeeded', base64:'...'}
params = JSON.parse(response.body);

puts params['message']

# ファイルに保存
File.open("download.pdf", "wb") do |file|
    file.write(Base64.decode64(params['base64']))
end
