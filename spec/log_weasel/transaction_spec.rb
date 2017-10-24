require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'active_support'

describe LogWeasel::Transaction do

  describe ".id" do

    it "is nil if not created" do
      expect(LogWeasel::Transaction.id).to be_nil
    end

  end

  describe ".id=" do
    before do
      LogWeasel::Transaction.id = "1234"
    end

    it "sets the id" do
      expect(LogWeasel::Transaction.id).to eq '1234'
    end

  end

  describe ".create" do
    before do
      SecureRandom.stubs(:hex).returns('94b2')
    end

    it 'creates a transaction id' do
      id = LogWeasel::Transaction.create
      expect(id).to eq'94b2'
    end

  end

  describe ".destroy" do
    before do
      LogWeasel::Transaction.create
    end

    it "removes transaction id" do
      LogWeasel::Transaction.destroy
      expect(LogWeasel::Transaction.id). to be_nil
    end
  end
end
