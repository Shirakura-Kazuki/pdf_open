Rails.application.routes.draw do
  root 'home#display'
  post 'send_notification', to: 'home#send_notification'  
  post 'send_pdf' , to:'home#send_pdf'
  # PDFファイル表示用ページ
  get 'open_pdf' , to:'home#open_pdf'
  get 'test' ,to:'home#test'
  post '/open_pdf', to: 'home#open_pdf'
  delete '/delete_pdf', to: 'home#delete_pdf'
  get 'display' , to:'home#display'


  # ファイルcheck関数テスト
  get '/check_file_exists' , to:'home#check_file_exists'
end
