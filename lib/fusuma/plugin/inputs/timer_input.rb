# frozen_string_literal: true

require_relative './input.rb'

module Fusuma
  module Plugin
    module Inputs
      # libinput commands wrapper
      class TimerInput < Input
        DEFAULT_INTERVAL = 0.3
        def config_param_types
          {
            'interval': [Float]
          }
        end

        attr_reader :writer

        def io
          @io ||= begin
                    reader, writer = create_io
                    @pid = start(reader, writer)

                    reader
                  end
        end

        def start(reader, writer)
          pid = fork do
            start_timer(reader, writer)
          end
          writer.close
          pid
        end

        def start_timer(reader, writer)
          reader.close
          loop do
            sleep interval
            writer.puts 'timer'
          end
        end

        private

        def create_io
          IO.pipe
        end

        def interval
          config_params(:interval) || DEFAULT_INTERVAL
        end
      end
    end
  end
end
