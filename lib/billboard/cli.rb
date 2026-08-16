# frozen_string_literal: true

require 'optparse'
require_relative 'options'
require_relative 'app'
require_relative 'errors'
require_relative 'logging'

module Billboard
  module CLI
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
    end

    def self.parser(options)
      OptionParser.new do |opts|
        opts.banner = 'Uso: billboard [opciones]'
        opts.on('--short', 'Información básica (título, fecha y hora)') { options.short = true }
        opts.on('--no-cache', 'Ignorar el caché y volver a pedir el rango a la API') { options.cache = false }
      end
    end
  end
end
