# frozen_string_literal: true

require_relative '../style'

module Billboard
  module Formatters
    module Full
      def self.format(events)
        return 'No hay funciones para el período seleccionado.' if events.empty?

        events.map { |event| line(event) }.join("\n")
      end

      def self.line(event)
        time = event.start_time
        "#{Style.title(event.title)}\n  #{Style.bold(time.strftime('%d/%m/%Y %H:%M'))}\n  #{event.url}"
      end
    end
  end
end
