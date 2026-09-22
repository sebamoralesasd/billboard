# frozen_string_literal: true

require 'date'
require 'time'

module Billboard
  class Repository
    TIMESTAMP_FORMAT = '%Y-%m-%d %H:%M:%S'

    def initialize(database, ttl_hours: ENV.fetch('BILLBOARD_CACHE_TTL', '24'))
      @connection = database.connection
      @ttl_hours = parse_ttl(ttl_hours)
    end

    def fresh_days_in(range)
      rows = connection.execute(
        'SELECT day FROM fetched_days WHERE day BETWEEN ? AND ? AND fetched_at >= ?',
        [*day_bounds(range), cutoff]
      )
      rows.map { |row| Date.strptime(row['day'], DateRange::DAY_FORMAT) }
    end

    def replace_in(range, events)
      connection.transaction do
        connection.execute('DELETE FROM events WHERE event_day BETWEEN ? AND ?', day_bounds(range))
        save(events)
        mark_fetched(range.each_day)
      end
    end

    def events_in(range)
      rows = connection.execute(
        'SELECT id, title, start_date, url FROM events ' \
        'WHERE event_day BETWEEN ? AND ? ORDER BY start_date',
        day_bounds(range)
      )
      rows.map { |row| to_event(row) }
    end

    private

    attr_reader :connection, :ttl_hours

    def cutoff
      (Time.now.utc - (ttl_hours * 3600)).strftime(TIMESTAMP_FORMAT)
    end

    def mark_fetched(days)
      now = Time.now.utc.strftime(TIMESTAMP_FORMAT)
      days.each do |day|
        connection.execute(<<~SQL, [day.strftime(DateRange::DAY_FORMAT), now])
          INSERT INTO fetched_days (day, fetched_at) VALUES (?, ?)
          ON CONFLICT(day) DO UPDATE SET fetched_at = excluded.fetched_at
        SQL
      end
    end

    def save(events)
      events.each do |event|
        connection.execute(<<~SQL, bind_params(event))
          INSERT INTO events (id, title, start_date, url, event_day)
          VALUES (?, ?, ?, ?, ?)
          ON CONFLICT(id) DO UPDATE SET
            title = excluded.title,
            start_date = excluded.start_date,
            url = excluded.url,
            event_day = excluded.event_day
        SQL
      end
    end

    def parse_ttl(value)
      Integer(value)
    rescue ArgumentError
      raise UsageError, "BILLBOARD_CACHE_TTL inválido: #{value} (se esperan horas enteras)"
    end

    def day_bounds(range)
      [range.start_date.strftime(DateRange::DAY_FORMAT), range.end_date.strftime(DateRange::DAY_FORMAT)]
    end

    def bind_params(event)
      [event.id, event.title, event.start_date, event.url, event.event_day]
    end

    def to_event(row)
      Event.new(
        id: row['id'],
        title: row['title'],
        start_date: row['start_date'],
        url: row['url']
      )
    end
  end
end
