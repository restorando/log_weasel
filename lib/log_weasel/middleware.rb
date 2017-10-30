class LogWeasel::Middleware

  def initialize(app, _options = {})
    @app = app
    @config = LogWeasel.config
  end

  # Get transaction ID from header, or create if missing and configured to do so.  If present (or created),
  # attach it as header so other apps use it as well.
  def call(env)
    LogWeasel::Transaction.set_or_create(env.fetch("HTTP_#{@config.header_name}", nil))

    status, headers, body = @app.call(env)

    headers[@config.header_name] = LogWeasel::Transaction.id if LogWeasel::Transaction.id.present?
    return [status, headers, body]
  ensure
    LogWeasel::Transaction.destroy
  end
end
