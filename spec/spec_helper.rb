$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "log_weasel"
require "rspec"

begin
  require "securerandom"
rescue
  require "active_support/secure_random"
end

RSpec.configure do |config|
  config.mock_with :mocha
end
