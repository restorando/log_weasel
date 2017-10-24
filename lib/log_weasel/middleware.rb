class LogWeasel::Middleware

  def initialize(app, _options = {})
    @app = app
    @config = LogWeasel.config
  end

  # Get transaction ID from header, or create if missing and configured to do so.  If present (or created),
  # attach it as header so the other app uses it as well.
  def call(env)
    # Get or create transaction ID
    transaction_id = env.fetch("HTTP_#{@config.header_name}", nil)
    if transaction_id.nil? && @config.generate_id_if_missing
      transaction_id = LogWeasel::Transaction.create
    end
    LogWeasel::Transaction.id = transaction_id unless transaction_id.nil?

    status, headers, body = @app.call(env)
    # Attach transaction ID to header if necessary
    headers[@config.header_name] = transaction_id unless transaction_id.nil?

    return [status, headers, body]
  ensure
    LogWeasel::Transaction.destroy
  end
end
