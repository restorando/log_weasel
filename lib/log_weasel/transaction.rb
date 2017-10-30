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

    # Get transaction ID. `nil` if not present.
    def self.id
      Thread.current[:log_weasel_id]
    end

    # Set transaction ID, or generate a new one if appropriate.
    # @param [Object] id The new transaction ID. If `nil`, and configured to generate IDs when missing, a new
    # ID will be generated.
    # @return [Object] The set or generated transaction ID. `nil` if neither set not generated.
    # rubocop:disable Style/AccessorMethodName
    def self.set_or_create(id = nil)
      if id.nil?
        create if LogWeasel.config.generate_id_if_missing
      else
        self.id = id
      end
    end
    # rubocop:enable Style/AccessorMethodName
  end
end
