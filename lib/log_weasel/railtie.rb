require "rails"

class LogWeasel::Railtie < Rails::Railtie

  initializer "log_weasel.configure" do |app|
    if LogWeasel.config.enabled
      app.config.middleware.insert_before "::Rails::Rack::Logger", "LogWeasel::Middleware"
    end
  end
end
