require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "log_weasel"

describe LogWeasel do

  describe ".configure" do
    context "when called with no args" do
      it "maintains default config" do
        expect { LogWeasel.configure {} }.to_not change(LogWeasel, :config)
      end
    end

    it "is disabled by default" do
      expect(LogWeasel.config.enabled).to be false
    end

    it "stores header name" do
      LogWeasel.configure do |config|
        config.header_name = 'X_TEST'
      end
      expect(LogWeasel.config.header_name).to eq 'X_TEST'
    end
  end

end
