# frozen_string_literal: true

require 'sqlite3'

module Billboard
  class Database
    SCHEMA_VERSION = 1

    attr_reader :connection

    def initialize(path = ENV.fetch('BILLBOARD_DB', 'billboard.db'))
      @connection = SQLite3::Database.new(path)
      @connection.results_as_hash = true
      migrate
      create_schema
    end

    def migrate
      return if connection.get_first_value('PRAGMA user_version') >= SCHEMA_VERSION

      connection.execute('DROP TABLE IF EXISTS fetched_days')
      connection.execute("PRAGMA user_version = #{SCHEMA_VERSION}")
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
          day TEXT PRIMARY KEY,
          fetched_at TEXT NOT NULL
        );
      SQL
    end
  end
end
