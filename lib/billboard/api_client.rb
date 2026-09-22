# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'

module Billboard
  class ApiClient
    DEFAULT_URL = 'https://elcairocinepublico.gob.ar/wp-json/tribe/events/v1/'
    TIMEOUT = 7
    PER_PAGE = 50
    LOG_OPTIONS = { headers: true, bodies: false, errors: true, log_level: :debug }.freeze
    RETRY_OPTIONS = {
      max: 2,
      interval: 0.5,
      backoff_factor: 2,
      exceptions: Faraday::Retry::Middleware::DEFAULT_EXCEPTIONS + [Faraday::ConnectionFailed, Faraday::ServerError]
    }.freeze

    def initialize
      @connection = build_connection
    end

    def fetch_events(range)
      events = []
      page = 1

      loop do
        body = request_page(range, page)
        events.concat(Array(body['events']).map { |data| build_event(data) })
        total_pages = body['total_pages'].to_i
        break if page >= total_pages || total_pages.zero?

        page += 1
      end

      events
    end

    private

    attr_reader :connection

    def request_page(range, page)
      Logging.logger.info("Consultando API página #{page} (#{range.api_start} - #{range.api_end})")
      response = connection.get('events') do |req|
        req.params['start_date'] = range.api_start
        req.params['end_date'] = range.api_end
        req.params['per_page'] = PER_PAGE
        req.params['page'] = page
      end
      response.body
    rescue Faraday::ParsingError
      raise ApiError, 'Respuesta inválida de la API'
    rescue Faraday::Error => e
      raise ApiError, "Fallo al consultar la API: #{e.message}"
    end

    def build_event(data)
      Event.new(
        id: data['id'],
        title: data['title'],
        start_date: data['start_date'],
        url: data['url']
      )
    end

    def build_connection
      Faraday.new(url: ENV.fetch('BILLBOARD_API_URL', DEFAULT_URL)) do |conn|
        conn.options.timeout = TIMEOUT
        conn.options.open_timeout = TIMEOUT
        conn.request :retry, **RETRY_OPTIONS
        conn.response :raise_error
        conn.response :json, content_type: //
        conn.response :logger, Logging.logger, **LOG_OPTIONS
      end
    end
  end
end
