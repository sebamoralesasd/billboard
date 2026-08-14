# frozen_string_literal: true

module Billboard
  module Style
    RESET = "\e[0m"
    BOLD = "\e[1m"
    YELLOW = "\e[33m"

    def self.enabled?
      $stdout.tty? && !ENV.key?('NO_COLOR')
    end

    def self.bold(text)
      enabled? ? "#{BOLD}#{text}#{RESET}" : text
    end

    def self.title(text)
      enabled? ? "#{BOLD}#{YELLOW}#{text}#{RESET}" : text
    end
  end
end
