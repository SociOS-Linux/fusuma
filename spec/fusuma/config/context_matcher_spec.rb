# frozen_string_literal: true

require "spec_helper"
require "./lib/fusuma/config/context_matcher"

module Fusuma
  RSpec.describe Config::ContextMatcher do
    describe ".match?" do
      context "when config_context is nil" do
        it "returns true" do
          expect(described_class.match?(nil, {application: "Chrome"})).to be true
        end
      end

      context "when config_context is empty" do
        it "returns true" do
          expect(described_class.match?({}, {application: "Chrome"})).to be true
        end
      end

      context "when request_context is nil and config_context has conditions" do
        it "returns false" do
          expect(described_class.match?({application: "Chrome"}, nil)).to be false
        end
      end

      context "when request_context is empty and config_context has conditions" do
        it "returns false" do
          expect(described_class.match?({application: "Chrome"}, {})).to be false
        end
      end

      context "with single value comparison" do
        it "returns true when values match" do
          config_context = {application: "Chrome"}
          request_context = {application: "Chrome"}
          expect(described_class.match?(config_context, request_context)).to be true
        end

        it "returns false when values do not match" do
          config_context = {application: "Chrome"}
          request_context = {application: "Firefox"}
          expect(described_class.match?(config_context, request_context)).to be false
        end

        it "returns true when boolean values match" do
          config_context = {thumbsense: true}
          request_context = {thumbsense: true}
          expect(described_class.match?(config_context, request_context)).to be true
        end

        it "returns false when boolean values do not match" do
          config_context = {thumbsense: true}
          request_context = {thumbsense: false}
          expect(described_class.match?(config_context, request_context)).to be false
        end
      end

      context "with array value (OR condition)" do
        it "returns true when actual matches any element" do
          config_context = {application: ["Chrome", "Firefox"]}
          request_context = {application: "Chrome"}
          expect(described_class.match?(config_context, request_context)).to be true
        end

        it "returns true when actual matches another element" do
          config_context = {application: ["Chrome", "Firefox"]}
          request_context = {application: "Firefox"}
          expect(described_class.match?(config_context, request_context)).to be true
        end

        it "returns false when actual matches no element" do
          config_context = {application: ["Chrome", "Firefox"]}
          request_context = {application: "Safari"}
          expect(described_class.match?(config_context, request_context)).to be false
        end
      end

      context "with multiple keys (AND condition)" do
        it "returns true when all keys match" do
          config_context = {thumbsense: true, application: "Chrome"}
          request_context = {thumbsense: true, application: "Chrome"}
          expect(described_class.match?(config_context, request_context)).to be true
        end

        it "returns false when some keys do not match" do
          config_context = {thumbsense: true, application: "Chrome"}
          request_context = {thumbsense: false, application: "Chrome"}
          expect(described_class.match?(config_context, request_context)).to be false
        end

        it "returns true when request_context has extra keys" do
          config_context = {application: "Chrome"}
          request_context = {thumbsense: true, application: "Chrome", extra: "value"}
          expect(described_class.match?(config_context, request_context)).to be true
        end

        it "returns false when config key is missing from request_context" do
          config_context = {thumbsense: true, application: "Chrome"}
          request_context = {application: "Chrome"}
          expect(described_class.match?(config_context, request_context)).to be false
        end
      end

      context "with combined conditions (AND + OR)" do
        it "returns true when both AND and OR conditions are satisfied" do
          config_context = {thumbsense: true, application: ["Chrome", "Firefox"]}
          request_context = {thumbsense: true, application: "Chrome"}
          expect(described_class.match?(config_context, request_context)).to be true
        end

        it "returns false when OR is satisfied but AND is not" do
          config_context = {thumbsense: true, application: ["Chrome", "Firefox"]}
          request_context = {thumbsense: false, application: "Chrome"}
          expect(described_class.match?(config_context, request_context)).to be false
        end

        it "returns false when AND is satisfied but OR is not" do
          config_context = {thumbsense: true, application: ["Chrome", "Firefox"]}
          request_context = {thumbsense: true, application: "Safari"}
          expect(described_class.match?(config_context, request_context)).to be false
        end
      end
    end
  end
end
