# frozen_string_literal: true

require 'date'
require_relative '../date_range'

module Billboard
  module DateRanges
    module Week
      WINDOW_DAYS = 7

      def self.build(_options)
        today = Date.today
        DateRange.for_days(today, today + (WINDOW_DAYS - 1))
      end
    end
  end
end
