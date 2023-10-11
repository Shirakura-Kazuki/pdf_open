Rails.application.routes.draw do
  root 'home#index'
  post 'send_notification', to: 'home#send_notification'  
  post 'send_pdf' , to:'home#send_pdf'
  # PDFファイル表示用ページ
  get 'open_pdf' , to:'home#open_pdf'
  get 'display' , to:'home#display'
end
