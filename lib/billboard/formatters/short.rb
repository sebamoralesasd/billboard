# frozen_string_literal: true

module Billboard
  module Formatters
    module Short
      extend Base

      def self.line(event)
        "#{time(event)}  #{Style.title(event.title)}"
      end
    end
  end
end
