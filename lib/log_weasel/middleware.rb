class LogWeasel::Middleware
  KEY_HEADER = 'X_LOGWEASEL_KEY'
  TRANSACTION_ID_HEADER = 'X_LOGWEASEL_TRANSACTION_ID'

  def initialize(app, options = {})
    @app = app
    @key = LogWeasel.config.key ? "#{LogWeasel.config.key}-WEB" : "WEB"
  end

  # TODO: Is this right? Do we even want to do this? I'm not sure
  # What I'm doing is getting transaction ID from header (or creating it if nonexistent) and attaching it as
  # header for the next request. Thing is, one of the two needs to happen:
  # a) The client stores the header and sends it in its next request
  # b) We add the header before calling `@app.call`, so that if the call is going elsewhere (ie. Redo-API)
  #    they will receive the header

  def call(env)
    key = env.fetch("HTTP_#{KEY_HEADER}", @key)
    # Get or create transaction ID
    transaction_id = env.fetch("HTTP_#{TRANSACTION_ID_HEADER}", nil)
    if transaction_id.nil?
      transaction_id = LogWeasel::Transaction.create(key)
    else
      LogWeasel::Transaction.id = transaction_id
    end
    status, headers, body = @app.call(env)
    # Attach transaction ID to header
    headers[TRANSACTION_ID_HEADER] = transaction_id

    return [status, headers, body]
  ensure
    LogWeasel::Transaction.destroy
  end
end
