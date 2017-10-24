require 'log_weasel/transaction'
require 'log_weasel/middleware'
require 'log_weasel/railtie' if defined? ::Rails::Railtie


module LogWeasel
  def self.config
    @@config ||= ActiveSupport::OrderedOptions.new(
      # TODO: Document
      enabled: false,
      header_name: 'X_TRANSACTION_ID',
      id_generator: nil,
      generate_id_if_missing: true
    )
  end

  def self.configure
    yield self.config
  end
end

#Rails.application.class.to_s.split("::").first
