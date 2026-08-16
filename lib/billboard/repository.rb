# frozen_string_literal: true

require_relative 'event'

module Billboard
  class Repository
    attr_reader :connection

    def initialize(database)
      @connection = database.connection
    end

    def fetched?(day)
      key = day.strftime('%Y-%m-%d')
      !connection.get_first_value('SELECT 1 FROM fetched_days WHERE day = ?', key).nil?
    end

    def mark_fetched(days)
      days.each do |day|
        connection.execute(
          'INSERT OR IGNORE INTO fetched_days (day) VALUES (?)',
          day.strftime('%Y-%m-%d')
        )
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

    def replace_in(range, events)
      connection.transaction do
        connection.execute('DELETE FROM events WHERE event_day BETWEEN ? AND ?', day_bounds(range))
        save(events)
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

    def day_bounds(range)
      [range.start_date.strftime('%Y-%m-%d'), range.end_date.strftime('%Y-%m-%d')]
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
