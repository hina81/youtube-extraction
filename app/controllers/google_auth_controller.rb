class GoogleAuthController < ApplicationController
  GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token"
  def get_access_token
    code = params[:code]

    response = HTTParty.post(GOOGLE_TOKEN_URL, {
      headers: { "Content-Type" => "application/x-www-form-urlencoded" },
      body: {
        code: code,
        client_id: "#{ENV['CLIENT_ID']}",
        client_secret: "#{ENV['CLIENT_SECRET']}",
        redirect_uri: "#{ENV['REDIRECT_URL']}",
        grant_type: "authorization_code"
      }
    })

    if response.code == 200
      # アクセストークンを取得
      @access_token = response["access_token"]
      refresh_token = response["refresh_token"]

      # セッションにトークンを保存
      session[:access_token] = @access_token
      session[:refresh_token] = refresh_token

      redirect_to youtube_api_get_liked_videos_path

      # render json: {
      #   access_token: @access_token,
      #   refresh_token: refresh_token,
      #   expires_in: response["expires_in"]
      # }
    else
      render json: { error: response["error"], description: response["error_description"] }, status: :bad_request
    end
  end

end
