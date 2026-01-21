# frozen_string_literal: true

require "spec_helper"
require "./lib/fusuma/config/index"

module Fusuma
  RSpec.describe Config::Index do
    describe Config::Index::Key do
      describe "#symbol" do
        context "when initialized with Integer" do
          it "returns Integer" do
            key = Config::Index::Key.new(3)
            expect(key.symbol).to eq(3)
            expect(key.symbol).to be_a(Integer)
          end
        end

        context "when initialized with Symbol" do
          it "returns Symbol" do
            key = Config::Index::Key.new(:swipe)
            expect(key.symbol).to eq(:swipe)
          end
        end

        context "when initialized with String" do
          it "returns Symbol for non-numeric string" do
            key = Config::Index::Key.new("swipe")
            expect(key.symbol).to eq(:swipe)
          end

          it "returns Integer for numeric string" do
            key = Config::Index::Key.new("3")
            expect(key.symbol).to eq(3)
            expect(key.symbol).to be_a(Integer)
          end

          it "returns Integer for multi-digit numeric string" do
            key = Config::Index::Key.new("42")
            expect(key.symbol).to eq(42)
            expect(key.symbol).to be_a(Integer)
          end

          it "returns Symbol for string with leading zeros" do
            key = Config::Index::Key.new("03")
            expect(key.symbol).to eq(:"03")
          end

          it "returns Symbol for mixed alphanumeric string" do
            key = Config::Index::Key.new("swipe3")
            expect(key.symbol).to eq(:swipe3)
          end
        end
      end
    end
  end
end
