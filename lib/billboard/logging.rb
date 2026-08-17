# frozen_string_literal: true

require 'logger'

module Billboard
  module Logging
    def self.logger
      @logger ||= build_logger
    end

    def self.build_logger
      logger = Logger.new($stderr)
      logger.level = ENV.fetch('BILLBOARD_LOG_LEVEL', 'WARN')
      logger.progname = 'billboard'
      logger
    end
  end
end
