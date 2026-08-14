# frozen_string_literal: true

require 'date'

module Billboard
  class DateRange
    API_FORMAT = '%Y-%m-%d %H:%M:%S'

    attr_reader :start_date, :end_date

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
