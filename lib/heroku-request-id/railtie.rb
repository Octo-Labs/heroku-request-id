module HerokuRequestId
  class Railtie < Rails::Railtie
    initializer 'heroku_request_id.add_middleware' do |app|
      app.config.middleware.insert_after 'Rack::Lock', "HerokuRequestId::Middleware"
    end
  end
end
