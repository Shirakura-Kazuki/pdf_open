Rails.application.routes.draw do
  root 'home#index'
  post 'send_notification', to: 'home#send_notification'  
  post 'send_pdf' , to:'home#send_pdf'
  # PDFファイル表示用ページ
  get 'open_pdf' , to:'home#open_pdf'
  get 'test' ,to:'home#test'
  post '/open_pdf', to: 'home#open_pdf'
  delete '/delete_pdf', to: 'home#delete_pdf'

  #/display読み込みテスト用
  get 'display' , to:'home#display'
end
