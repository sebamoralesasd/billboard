# frozen_string_literal: true

require 'time'

module Billboard
  class Event
    attr_reader :id, :title, :start_date, :url

    def initialize(id:, title:, start_date:, url:)
      @id = id
      @title = title
      @start_date = start_date
      @url = url
    end

    def start_time
      @start_time ||= Time.parse(start_date)
    end

    def event_day
      start_time.strftime('%Y-%m-%d')
    end
  end
end
