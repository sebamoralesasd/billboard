# frozen_string_literal: true

module Billboard
  module DateRangeResolver
    DATE_RANGES = {
      default: DateRanges::Default,
      custom: DateRanges::Custom,
      week: DateRanges::Week,
      month: DateRanges::Month
    }.freeze

    def self.resolve(options)
      strategy = DATE_RANGES[options.range_key]
      raise InvalidRangeError, "Rango desconocido: #{options.range_key}" unless strategy

      strategy.build(options)
    end
  end
end
