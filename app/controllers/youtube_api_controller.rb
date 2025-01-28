class YoutubeApiController < ApplicationController
  def get_liked_videos
    # アクセストークンの取得
    @access_token = session[:access_token]

    if @access_token
      option = {
        part: "snippet",                  # 動画の基本情報
        myRating: "like",                 # いいねした動画のみ
        maxResults: 50,
        categoryId: 26,
        access_token: @access_token
      }

      uri =
        URI.parse(
          "https://www.googleapis.com/youtube/v3/videos?part=#{option[:part]}&maxResults=#{option[:maxResults]}&myRating=#{option[:myRating]}&categoryId=#{option[:categoryId]}",
        )


      # HTTPS設定
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE

      # ヘッダー設定
      headers = { "Authorization" => "Bearer #{@access_token}" }

      # リクエスト作成
      req = Net::HTTP::Get.new(uri.request_uri)
      req.initialize_http_header(headers)

      # APIリクエスト実行
      response = https.request(req)

      # レスポンスの処理(ハッシュ形式に変換)
      response = response.body.force_encoding("UTF-8")
      response = JSON.parse(response)

      render json: response["items"]

      # @items = response["items"]

    else
      render json: { error: "Access token is missing" }, status: :unauthorized
    end
  end
end
