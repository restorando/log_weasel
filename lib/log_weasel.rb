require 'log_weasel/transaction'
require 'log_weasel/middleware'
require 'log_weasel/railtie' if defined? ::Rails::Railtie
require 'hashie'

module LogWeasel
  def self.config
    @@config ||= Hashie::Mash.new(
      # TODO: Document
      enabled: false,
      header_name: 'X_TRANSACTION_ID',
      id_generator: lambda { SecureRandom.hex(10) },
      generate_id_if_missing: true
    )
  end

  def self.configure
    yield self.config
  end
end
