# frozen_string_literal: true

require_relative '../style'

module Billboard
  module Formatters
    module Short
      def self.format(events)
        return 'No hay funciones para el período seleccionado.' if events.empty?

        events.map { |event| line(event) }.join("\n")
      end

      def self.line(event)
        "#{Style.bold(event.start_time.strftime('%d/%m/%Y %H:%M'))}  #{Style.title(event.title)}"
      end
    end
  end
end
