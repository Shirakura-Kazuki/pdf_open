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
  

  post '/delete_file', to: 'home#delete_file'
  


  #パラメータ付きURLテスト
  get '/display_n', to: 'home#index'
  get 'display', to:'home#display'

  post '/check_file', to:'home#check_file'

 

  get 'htmlfile_download', to: 'home#htmlfile_download'
  get 'event1' , to: 'home#event1'


end
