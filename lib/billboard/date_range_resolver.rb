# frozen_string_literal: true

require_relative 'date_ranges/default'
require_relative 'date_ranges/custom'
require_relative 'date_ranges/week'
require_relative 'errors'

module Billboard
  module DateRangeResolver
    DATE_RANGES = {
      default: DateRanges::Default,
      custom: DateRanges::Custom,
      week: DateRanges::Week
    }.freeze

    def self.resolve(options)
      strategy = DATE_RANGES[options.range_key]
      raise InvalidRangeError, "Rango desconocido: #{options.range_key}" unless strategy

      strategy.build(options)
    end
  end
end
