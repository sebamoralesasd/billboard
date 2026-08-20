# frozen_string_literal: true

require 'date'
require_relative '../date_range'

module Billboard
  module DateRanges
    module Month
      def self.build(_options)
        today = Date.today
        last_day = Date.new(today.year, today.month, -1)
        DateRange.for_days(today, last_day)
      end
    end
  end
end
