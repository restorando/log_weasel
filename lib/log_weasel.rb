require 'log_weasel/transaction'
require 'log_weasel/middleware'
require 'log_weasel/railtie' if defined? ::Rails::Railtie


module LogWeasel
  class Config
    attr_accessor :key
  end

  def self.config
    @@config ||= Config.new
  end

  def self.configure
    yield self.config
  end
end

#Rails.application.class.to_s.split("::").first
