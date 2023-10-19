class HomeController < ApplicationController
    #CRSF
    skip_before_action :verify_authenticity_token, only: [:open_pdf,:delete_file,:check_file]

    def index
        # @id = params[:id]
    end

    def send_id
        # render json: { id: "1" }
    end

    #JSONデータ：curl -X POST -H "Content-Type: application/json" -d "{""keycode"": ""download_SO1AZAhF9C1o7kaB52CK"", ""id_1"": ""1Cb3pJG-8A6LCY8XvlXl_vgCjPk9OoJxu"", ""display"": ""1"",""id_2"": ""1Cb3pJG-8A6LCY8XvlXl_vgCjPk9OoJxu"", ""display"": ""2""}" http://localhost:3000/open_pdf

    def open_pdf 
        # パラメータをローカル変数に格納
        @keycode = params[:keycode]
        @id = params[:id]  #file_id→id_1 , :id→:id_1
        @display= params[:display] #1
       

        @path = Rails.root.join('public', 'temp', "display#{@display}", "download_#{@display}.pdf").to_s

       # パラメータの存在確認と処理
        if @id && @display
            # id_1とdisplay_1に対する処理（例：環境変数の設定）
            ENV['FILE_ID'] = @id
            ENV['DISPLAY'] = @display
            ENV['DOWNLOAD_PATH'] = @path
        end

    
        # 外部スクリプトへ値を受け渡す
        ENV['KEYCODE'] = @keycode

        #専用ID：現在表示のPDF
        @Pusher_id = "display#{@display}:" + @id

        # 外部のRubyスクリプトを実行
        look = system("ruby C:/Users/s_k_t/pusher_test1010_app/config/download.rb")
        

        if look
            begin
              Pusher.trigger(ENV['CHANNELNAME'], ENV['EVENTNAME'] + @display , { message: @Pusher_id })
              head :ok
            rescue => e
              render json: { error: "Pusherでエラーが発生しました: #{e.message}" }, status: :internal_server_error
            end
        end


    end
  
    def display
        authenticate_or_request_with_http_basic do |name, password|
            name == ENV['BASIC_AUTH_NAME'] && password == ENV['BASIC_AUTH_PASWORD']
        end
    end
  
   
    def submonitor
       
    end


    def delete_file
        # PDFファイルを削除するロジックをこちらに追加
        #指定されたパスにあるファイル削除　if　:`public/temp/download.pdf`というパスにファイルが存在する場合、そのファイルを削除する
        @display = params[:display2]
        
        file_path = Rails.root.join('public', 'temp', "display#{@display}", "download_#{@display}.pdf")
        File.delete(file_path) if File.exist?(file_path)
        head :ok    
    end
   
  
    # /download.pdf：チェック関数
    def check_file
        @display = params[:display2]

        #file_path = Rails.root.join('public', 'temp', 'display' + @display.to_s,'download_'+ @display.to_s +'.pdf')
        file_path = Rails.root.join('public', 'temp', "display#{@display}", "download_#{@display}.pdf")


        if File.exist?(file_path)

        # ファイルが存在する場合の処理
        render json: { message: 'File exists' }, status: :ok
        else
        # ファイルが存在しない場合の処理
        render json: { message: 'File does not exist' }, status: :not_found
        end

    end

    # def event1
    #     gon.event_key=ENV['EVENTNAME']
    # end
       
end

 
