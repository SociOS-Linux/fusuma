# frozen_string_literal: true

module Fusuma
  class Config
    # Matches context conditions for configuration lookup.
    # Supports AND (multiple keys) and OR (array values) conditions.
    class ContextMatcher
      class << self
        # Check if config context matches request context.
        # @param config_context [Hash, nil] context defined in YAML config
        # @param request_context [Hash, nil] context from runtime
        # @return [Boolean] true if matched
        #: (Hash[untyped, untyped]?, Hash[untyped, untyped]?) -> bool
        def match?(config_context, request_context)
          return true if config_context.nil? || config_context.empty?
          return false if request_context.nil? || request_context.empty?

          config_context.all? do |key, expected_value|
            match_value?(expected_value, request_context[key])
          end
        end

        private

        # @param expected [Object] expected value (single or array for OR)
        # @param actual [Object] actual value from request context
        # @return [Boolean] true if matched
        #: (untyped, untyped) -> bool
        def match_value?(expected, actual)
          case expected
          when Array
            expected.include?(actual)
          else
            expected == actual
          end
        end
      end
    end
  end
end
