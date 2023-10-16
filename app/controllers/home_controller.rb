class HomeController < ApplicationController
    #CRSF
    skip_before_action :verify_authenticity_token, only: [:open_pdf,:delete_pdf]

    def index

    end
  

    def send_pdf
        # original_url = params[:pdf_url]        
        # modified_url = original_url.split("/view?").first + "/preview"

        # Pusher.trigger('my-channel' , 'my-event', {
        #     message:modified_url
        # })
        # head :ok
    end

    def open_pdf
        # パラメータをローカル変数に格納
        @keycode = params[:keycode]
        @file_id = params[:id]

        # # パラメータの存在確認
        # if @file_id
        #     render json: { message: "処理を開始します" }, status: :ok
        # else
        #     render json: { error: "受信待ち" }, status: :bad_request
        #     return
        # end
    
        # PDFのURLを修正
        original_url = @file_id.to_s
        @modified_url =  "https://drive.google.com/file/d/"+ original_url + "/preview"

        # #Pusherでイベントをトリガー
        begin
            Pusher.trigger('my-channel', 'my-event', { message:"処理を開始します" })
            head :ok
        rescue => e
            render json: { error: "Pusherでエラーが発生しました: #{e.message}" }, status: :internal_server_error
        end


        # 外部スクリプトへ値を受け渡す
        ENV['KEYCODE'] = @keycode
        ENV['FILE_ID'] = @file_id

        # PDFファイルの保存先指定（public/temp/ディレクトリ内）
        ENV['DOWNLOAD_PATH'] = Rails.root.join('public', 'temp', 'download.pdf').to_s

        # 外部のRubyスクリプトを実行
        system("ruby C:/Users/s_k_t/pusher_test1010_app/config/download.rb")

    end
  
    def display

    end

    def delete_pdf
        # PDFファイルを削除するロジックをこちらに追加
        File.delete(Rails.root.join('public', 'temp', 'download.pdf')) if File.exist?(Rails.root.join('public', 'temp', 'download.pdf'))
        head :ok
    end
      
    # /download.pdf：チェック関数（TEST）
    def check_file_exists
        file_path = Rails.root.join('public', 'temp', 'download.pdf')
        
        if File.exist?(file_path)
          # ファイルが存在する場合の処理
          render json: { message: 'File exists' }, status: :ok
        else
          # ファイルが存在しない場合の処理
          render json: { message: 'File does not exist' }, status: :not_found
        end
      end

end
  