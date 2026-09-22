# frozen_string_literal: true

require 'logger'

module Billboard
  module Logging
    def self.logger
      @logger ||= build_logger
    end

    def self.build_logger
      logger = Logger.new($stderr)
      logger.progname = 'billboard'
      apply_level(logger, ENV.fetch('BILLBOARD_LOG_LEVEL', 'WARN'))
      logger
    end

    def self.apply_level(logger, level)
      logger.level = level
    rescue ArgumentError
      logger.level = Logger::WARN
      logger.warn("BILLBOARD_LOG_LEVEL inválido: #{level}. Se usa WARN")
    end

    private_class_method :build_logger, :apply_level
  end
end
