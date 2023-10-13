class HomeController < ApplicationController
    #CRSF
    skip_before_action :verify_authenticity_token, only: [:open_pdf]


    def index
    end
  

    def send_pdf
        original_url = params[:pdf_url]        
        modified_url = original_url.split("/view?").first + "/preview"

        Pusher.trigger('my-channel' , 'my-event', {
            message:modified_url
        })
        head :ok
    end

    def open_pdf
        # パラメータをローカル変数に格納
        document_id = params[:id]
        filename = params[:pdf_filename]
        author = params[:author]
        file_url = params[:pdf_file_id]

        # パラメータの存在確認
        unless file_url
            render json: { error: "受信待ち" }, status: :bad_request
            return
        end
    
        # PDFのURLを修正
        original_url = file_url.to_s
        modified_url =  "https://drive.google.com/file/d/"+ original_url + "/preview"
        
        # Pusherでイベントをトリガー
        begin
            Pusher.trigger('my-channel', 'my-event', { message: modified_url })
            head :ok
        rescue => e
            render json: { error: "Pusherでエラーが発生しました: #{e.message}" }, status: :internal_server_error
        end
    end
  
  

    def display
    end

    def test
    end

  end
  