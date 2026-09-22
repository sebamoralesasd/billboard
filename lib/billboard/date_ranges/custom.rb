# frozen_string_literal: true

require 'date'

module Billboard
  module DateRanges
    module Custom
      def self.build(options)
        first_day = options.from || Date.today
        last_day = options.to || (first_day + (Default::WINDOW_DAYS - 1))
        raise InvalidRangeError, '--from no puede ser posterior a --to' if first_day > last_day

        DateRange.for_days(first_day, last_day)
      end
    end
  end
end
