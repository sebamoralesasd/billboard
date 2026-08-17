# frozen_string_literal: true

require 'date'

module Billboard
  class DateRange
    API_FORMAT = '%Y-%m-%d %H:%M:%S'
    END_OF_DAY_SECONDS = (23 * 3600) + (59 * 60) + 59

    attr_reader :start_date, :end_date

    def self.for_days(first_day, last_day)
      new(first_day.to_time, last_day.to_time + END_OF_DAY_SECONDS)
    end

    def initialize(start_date, end_date)
      @start_date = start_date
      @end_date = end_date
    end

    def each_day
      (start_date.to_date..end_date.to_date).to_a
    end

    def api_start
      start_date.strftime(API_FORMAT)
    end

    def api_end
      end_date.strftime(API_FORMAT)
    end
  end
end
