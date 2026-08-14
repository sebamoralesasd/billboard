# frozen_string_literal: true

module Billboard
  class Options
    attr_accessor :range_key, :from, :to
    attr_writer :short

    def initialize
      @range_key = :default
      @short = false
      @from = nil
      @to = nil
    end

    def short?
      @short
    end
  end
end
