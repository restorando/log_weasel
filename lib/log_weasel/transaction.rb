begin
  require "securerandom"
rescue
  require "active_support/secure_random"
end

module LogWeasel
  module Transaction
    def self.create
      Thread.current[:log_weasel_id] = LogWeasel.config.id_generator.call.to_s
    end

    def self.destroy
      Thread.current[:log_weasel_id] = nil
    end

    def self.id=(id)
      Thread.current[:log_weasel_id] = id
    end

    def self.id
      Thread.current[:log_weasel_id]
    end
  end
end
