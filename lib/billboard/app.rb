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
      missing = range.each_day.reject { |day| repository.fetched?(day) }
      if missing.empty?
        Logging.logger.info('Todas las fechas están en caché')
        return
      end

      fetch_range = DateRange.new(missing.min.to_time, missing.max.to_time + 86_399)
      events = api_client.fetch_events(fetch_range)
      repository.save(events)
      repository.mark_fetched(missing)
    end

    def formatter
      options.short? ? Formatters::Short : Formatters::Full
    end
  end
end
