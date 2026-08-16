# frozen_string_literal: true

require_relative 'date_range'
require_relative 'date_range_resolver'
require_relative 'database'
require_relative 'repository'
require_relative 'api_client'
require_relative 'formatters/full'
require_relative 'formatters/short'
require_relative 'logging'

module Billboard
  class App
    attr_reader :options, :repository, :api_client

    def initialize(options, repository: Repository.new(Database.new), api_client: ApiClient.new)
      @options = options
      @repository = repository
      @api_client = api_client
    end

    def run
      range = DateRangeResolver.resolve(options)
      ensure_cached(range)
      events = repository.events_in(range)
      puts formatter.format(events)
    end

    def ensure_cached(range)
      days = days_to_fetch(range)
      if days.empty?
        Logging.logger.info('Todas las fechas están en caché')
        return
      end

      fetch_range = DateRange.new(days.min.to_time, days.max.to_time + 86_399)
      events = api_client.fetch_events(fetch_range)
      repository.replace_in(fetch_range, events)
      repository.mark_fetched(days)
    end

    def days_to_fetch(range)
      return range.each_day.reject { |day| repository.fetched?(day) } if options.cache?

      Logging.logger.info('Ignorando caché: se refresca todo el rango')
      range.each_day
    end

    def formatter
      options.short? ? Formatters::Short : Formatters::Full
    end
  end
end
