# frozen_string_literal: true

require_relative 'date_ranges/default'
require_relative 'errors'

module Billboard
  module DateRangeResolver
    DATE_RANGES = {
      default: DateRanges::Default
    }.freeze

    def self.resolve(options)
      strategy = DATE_RANGES[options.range_key]
      raise InvalidRangeError, "Rango desconocido: #{options.range_key}" unless strategy

      strategy.build(options)
    end
  end
end
