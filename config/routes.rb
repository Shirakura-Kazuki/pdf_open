Rails.application.routes.draw do
  root 'home#display'
  post 'send_notification', to: 'home#send_notification'  
  post 'send_pdf' , to:'home#send_pdf'
  # PDFファイル表示用ページ
  get 'open_pdf' , to:'home#open_pdf'
  get 'test' ,to:'home#test'
  post '/open_pdf', to: 'home#open_pdf'
  

  get 'display' , to:'home#display'
  get 'submonitor' , to:'home#submonitor'


  # ファイルcheck関数テスト
  get '/check_file_1' , to:'home#check_file_1'
  get '/check_file_2' , to:'home#check_file_2'

  delete '/delete_pdf_1', to: 'home#delete_pdf_1'
  delete '/delete_pdf_2', to: 'home#delete_pdf_2'
end
