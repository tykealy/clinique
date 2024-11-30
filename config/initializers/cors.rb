# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://127.0.0.1:5500'
    resource '*', headers: :any, methods: :any, credentials: true
  end
end
