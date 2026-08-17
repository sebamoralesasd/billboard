# frozen_string_literal: true

require 'date'
require 'optparse'
require_relative 'options'
require_relative 'app'
require_relative 'errors'
require_relative 'logging'

module Billboard
  module CLI
    DATE_FORMAT = '%Y-%m-%d'
    DATE_PATTERN = /\A\d{4}-\d{2}-\d{2}\z/.freeze

    def self.run(argv)
      options = parse(argv)
      App.new(options).run
    rescue Billboard::Error => e
      Logging.logger.error(e.message)
      warn(e.message)
      exit(1)
    end

    def self.parse(argv)
      options = Options.new
      parser(options).parse(argv)
      options
    rescue OptionParser::ParseError => e
      raise UsageError, e.message
    end

    def self.parser(options)
      OptionParser.new do |opts|
        opts.banner = 'Uso: billboard [opciones]'
        range_options(opts, options)
        opts.on('--short', 'Información básica (título, fecha y hora)') { options.short = true }
        opts.on('--no-cache', 'Ignorar el caché y volver a pedir el rango a la API') { options.cache = false }
      end
    end

    def self.range_options(opts, options)
      opts.on('--from DATE', 'Películas desde DATE (YYYY-MM-DD)') do |value|
        options.from = parse_date(value, '--from')
        options.range_key = :custom
      end
      opts.on('--to DATE', 'Películas hasta DATE (YYYY-MM-DD)') do |value|
        options.to = parse_date(value, '--to')
        options.range_key = :custom
      end
    end

    def self.parse_date(value, flag)
      raise InvalidRangeError, invalid_date_message(value, flag) unless value.match?(DATE_PATTERN)

      Date.strptime(value, DATE_FORMAT)
    rescue Date::Error
      raise InvalidRangeError, invalid_date_message(value, flag)
    end

    def self.invalid_date_message(value, flag)
      "Fecha inválida en #{flag}: #{value} (formato esperado YYYY-MM-DD)"
    end
  end
end
