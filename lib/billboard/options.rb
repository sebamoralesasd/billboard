# frozen_string_literal: true

module Billboard
  class Options
    attr_accessor :range_key, :from, :to
    attr_writer :short, :cache

    def initialize
      @range_key = :default
      @short = false
      @cache = true
      @from = nil
      @to = nil
    end

    def short?
      @short
    end

    def cache?
      @cache
    end
  end
end
