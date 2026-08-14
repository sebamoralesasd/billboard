# frozen_string_literal: true

require 'sqlite3'

module Billboard
  class Database
    attr_reader :connection

    def initialize(path = ENV.fetch('BILLBOARD_DB', 'billboard.db'))
      @connection = SQLite3::Database.new(path)
      @connection.results_as_hash = true
      create_schema
    end

    def create_schema
      connection.execute_batch(<<~SQL)
        CREATE TABLE IF NOT EXISTS events (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          start_date TEXT NOT NULL,
          url TEXT,
          event_day TEXT NOT NULL
        );
        CREATE INDEX IF NOT EXISTS idx_events_event_day ON events (event_day);
        CREATE TABLE IF NOT EXISTS fetched_days (
          day TEXT PRIMARY KEY
        );
      SQL
    end
  end
end
