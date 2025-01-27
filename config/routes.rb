Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  Rails.application.routes.draw do
    get "auth/google_oauth2/callback", to: "google_auth#get_access_token"
  end

  root "homes#top"
end
