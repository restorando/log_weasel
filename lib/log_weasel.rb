require "log_weasel/transaction"
require "log_weasel/middleware"
require "log_weasel/railtie" if defined? ::Rails::Railtie

module LogWeasel
  class Config
    attr_accessor :enabled, :header_name, :id_generator, :generate_id_if_missing

    def initialize
      # Set defaults TODO document
      @enabled = false
      @header_name = "X_TRANSACTION_ID"
      @id_generator = lambda { SecureRandom.hex(10) }
      @generate_id_if_missing = true
    end
  end


  def self.config
    @@config ||= Config.new
  end

  def self.configure
    yield config
  end
end
