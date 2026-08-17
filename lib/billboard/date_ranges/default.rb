# frozen_string_literal: true

require_relative '../date_range'

module Billboard
  module DateRanges
    module Default
      WINDOW_DAYS = 30

      def self.build(_options)
        today = Date.today
        DateRange.for_days(today, today + WINDOW_DAYS)
      end
    end
  end
end
