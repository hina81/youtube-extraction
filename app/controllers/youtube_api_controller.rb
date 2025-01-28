class YoutubeApiController < ApplicationController
  def get_liked_videos
    # アクセストークンの取得
    @access_token = session[:access_token]

    if @access_token
      option = {
        part: "snippet",                  # 動画の基本情報
        myRating: "like",                 # いいねした動画のみ
        maxResults: 50,
        access_token: @access_token
      }

      uri =
        URI.parse(
          "https://www.googleapis.com/youtube/v3/videos?part=#{option[:part]}&maxResults=#{option[:maxResults]}&myRating=#{option[:myRating]}",
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

      # render json: response["items"]

      # @items = response["items"]
      # @items = response["items"].select { |item| item["snippet"]["categoryId"].to_i == 26 }

      @categories = [
        [ "全ジャンル", nil ],
        [ "映画とアニメ", 1 ],
        [ "自動車と乗り物", 2 ],
        [ "音楽", 10 ],
        [ "ペットと動物", 15 ],
        [ "スポーツ", 17 ],
        [ "旅行とイベント", 19 ],
        [ "ゲーム", 20 ],
        [ "ブログ", 22 ],
        [ "コメディー", 23 ],
        [ "エンターテイメント", 24 ],
        [ "ニュースと政治", 25 ],
        [ "ハウツーとスタイル", 26 ],
        [ "教育", 27 ],
        [ "科学と技術", 28 ]
      ]

      # 選択されたカテゴリIDを取得
      category_id = params[:category_id].presence&.to_i

      @items = if category_id
                response["items"].select { |item| item["snippet"]["categoryId"].to_i == category_id }
      else
                response["items"]
      end

    else
      render json: { error: "Access token is missing" }, status: :unauthorized
    end
  end
end
