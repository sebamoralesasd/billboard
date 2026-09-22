# frozen_string_literal: true

module Billboard
  class App
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

    private

    attr_reader :options, :repository, :api_client

    def ensure_cached(range)
      days = days_to_fetch(range)
      if days.empty?
        Logging.logger.info('Todas las fechas están en caché')
        return
      end

      consecutive_runs(days).each { |run| refresh(DateRange.for_days(run.first, run.last)) }
    end

    def days_to_fetch(range)
      return range.each_day - repository.fresh_days_in(range) if options.cache?

      Logging.logger.info('Ignorando caché: se refresca todo el rango')
      range.each_day
    end

    def consecutive_runs(days)
      days.slice_when { |day, next_day| next_day != day + 1 }
    end

    def refresh(range)
      events = api_client.fetch_events(range)
      repository.replace_in(range, events)
    end

    def formatter
      options.short? ? Formatters::Short : Formatters::Full
    end
  end
end
