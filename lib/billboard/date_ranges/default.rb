# frozen_string_literal: true

require_relative '../date_range'

module Billboard
  module DateRanges
    module Default
      WINDOW_DAYS = 30

      def self.build(_options)
        today = Date.today
        start_date = today.to_time
        end_date = (today + WINDOW_DAYS).to_time + (23 * 3600) + (59 * 60) + 59
        DateRange.new(start_date, end_date)
      end
    end
  end
end
