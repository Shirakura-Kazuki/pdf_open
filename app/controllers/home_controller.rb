class HomeController < ApplicationController
    #CRSF
    skip_before_action :verify_authenticity_token, only: [:open_pdf,:delete_pdf_1,:delete_pdf_2]

    def index

    end

    def send_pdf
   
    end

    #JSONデータ：curl -X POST -H "Content-Type: application/json" -d "{""keycode"": ""download_SO1AZAhF9C1o7kaB52CK"", ""id_1"": ""1Cb3pJG-8A6LCY8XvlXl_vgCjPk9OoJxu"", ""display"": ""1"",""id_2"": ""1Cb3pJG-8A6LCY8XvlXl_vgCjPk9OoJxu"", ""display"": ""2""}" http://localhost:3000/open_pdf

    def open_pdf 
        # パラメータをローカル変数に格納
        @keycode = params[:keycode]
        @id_1 = params[:id_1]  #file_id→id_1 , :id→:id_1
        #add
        @display_1 = params[:display_1]
        @id_2 = params[:id_2]
        @display_2 = params[:display_2] 

       # パラメータの存在確認と処理
        if @id_1 && @display_1
            # id_1とdisplay_1に対する処理（例：環境変数の設定）
            ENV['FILE_ID_1'] = @id_1
            ENV['DISPLAY_1'] = @display_1
            ENV['DOWNLOAD_PATH_1'] = Rails.root.join('public', 'temp', 'display1','download_1.pdf').to_s
        end

        if @id_2 && @display_2
            # id_2とdisplay_2に対する処理（例：環境変数の設定）
            ENV['FILE_ID_2'] = @id_2
            ENV['DISPLAY_2'] = @display_2
            ENV['DOWNLOAD_PATH_2'] = Rails.root.join('public', 'temp', 'display2','download_2.pdf').to_s
        end
    
        # 外部スクリプトへ値を受け渡す
        ENV['KEYCODE'] = @keycode

        #専用ID：現在表示のPDF
        @Pusher_id1 = "display1:" + @id_1
        @Pusher_id2 = "display2:" + @id_2
       
        # # PDFファイルの保存先指定（public/temp/ディレクトリ内）
        # ENV['DOWNLOAD_PATH'] = Rails.root.join('public', 'temp', 'download.pdf').to_s

        # 外部のRubyスクリプトを実行
        look_1 = system("ruby C:/Users/s_k_t/pusher_test1010_app/config/download_1.rb")
        look_2 = system("ruby C:/Users/s_k_t/pusher_test1010_app/config/download_2.rb")

        
        if look_1 && look_2
            # 両方がtrueの場合：Pusherでイベントをトリガー
            begin
              Pusher.trigger('my-channel', 'my-event', { message: @Pusher_id1 + @Pusher_id2 })
              head :ok
            rescue => e
              render json: { error: "Pusherでエラーが発生しました: #{e.message}" }, status: :internal_server_error
            end
          elsif look_1 && !look_2
            # look_1はtrueだがlook_2がfalseの場合
            render json: { error: "look_2: NGの為、再発行してください" }, status: :internal_server_error
          elsif !look_1 && look_2
            # look_1はfalseだがlook_2がtrueの場合
            render json: { error: "look_1: NGの為、再発行してください" }, status: :internal_server_error
          else
            # 両方がfalseの場合
            render json: { error: "ステータス異常！！再発行してください" }, status: :internal_server_error
        end

    end
  
    def display

    end

    def submonitor

    end


    def delete_pdf_1
        # PDFファイルを削除するロジックをこちらに追加
        #指定されたパスにあるファイル削除　if　:`public/temp/download.pdf`というパスにファイルが存在する場合、そのファイルを削除する
        File.delete(Rails.root.join('public', 'temp', 'display1','download_1.pdf')) if File.exist?(Rails.root.join('public', 'temp', 'display1','download_1.pdf'))
        head :ok    #clientへレスポンス
    end
    
    def delete_pdf_2
        # PDFファイルを削除するロジックをこちらに追加
        #指定されたパスにあるファイル削除　if　:`public/temp/download.pdf`というパスにファイルが存在する場合、そのファイルを削除する
        File.delete(Rails.root.join('public', 'temp', 'display2','download_2.pdf')) if File.exist?(Rails.root.join('public', 'temp', 'display2','download_2.pdf'))
        head :ok    #clientへレスポンス
    end

    # /download.pdf：チェック関数
    def check_file_1
        
        file_path = Rails.root.join('public', 'temp', 'display1','download_1.pdf')

        if File.exist?(file_path)

        # ファイルが存在する場合の処理
        render json: { message: 'File exists' }, status: :ok
        else
        # ファイルが存在しない場合の処理
        render json: { message: 'File does not exist' }, status: :not_found
        end

    end

    def check_file_2
        
        file_path = Rails.root.join('public', 'temp', 'display2','download_2.pdf')

        if File.exist?(file_path)

        # ファイルが存在する場合の処理
        render json: { message: 'File exists' }, status: :ok
        else
        # ファイルが存在しない場合の処理
        render json: { message: 'File does not exist' }, status: :not_found
        end

    end

end