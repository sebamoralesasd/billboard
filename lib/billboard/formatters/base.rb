# frozen_string_literal: true

module Billboard
  module Formatters
    module Base
      EMPTY_MESSAGE = 'No hay funciones para el período seleccionado.'
      TIME_FORMAT = '%d/%m/%Y %H:%M'

      def format(events)
        return EMPTY_MESSAGE if events.empty?

        events.map { |event| line(event) }.join("\n")
      end

      def time(event)
        Style.bold(event.start_time.strftime(TIME_FORMAT))
      end
    end
  end
end
