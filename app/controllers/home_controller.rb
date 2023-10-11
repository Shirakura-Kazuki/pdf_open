class HomeController < ApplicationController
    def index
    end
  
    def send_notification
      Pusher.trigger('my-channel', 'my-event', {
        message: 'hello world'
      })
      head :ok
    end

    def send_pdf
        Pusher.trigger('my-channel', 'my-event', {
          message: 'https://drive.google.com/file/d/1cHCuA0wAwfXLem68W2Sz1lp8DZ_tgD7G/view?usp=drive_link'  #Googleドライブ内のファイル表示用
          #message: 'https://drive.google.com/file/d/1gO5r0Gm2DjwU_AcKjLVzsNMJxTXbD0ZP/view?usp=drive_link'
        })
        head :ok
    end

    def open_pdf
    end

    def display
    end

  end
  