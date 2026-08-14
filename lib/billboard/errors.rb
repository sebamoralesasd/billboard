# frozen_string_literal: true

module Billboard
  class Error < StandardError; end

  class ApiError < Error; end

  class InvalidRangeError < Error; end
end
