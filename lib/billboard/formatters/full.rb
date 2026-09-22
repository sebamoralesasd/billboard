# frozen_string_literal: true

module Billboard
  module Formatters
    module Full
      extend Base

      def self.line(event)
        "#{Style.title(event.title)}\n  #{time(event)}\n  #{event.url}"
      end
    end
  end
end
