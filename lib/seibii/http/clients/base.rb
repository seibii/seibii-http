# frozen_string_literal: true

module Seibii
  module Http
    module Clients
      class Base
        def initialize(logger: nil)
          @logger = logger
        end

        def request(method:, uri:, request_body: nil, headers: {})
          parsed_uri = URI.parse(uri)
          with_logging(uri) { http(parsed_uri).request(request_object(method, parsed_uri, request_body, headers)) }
            .yield_self { |response| handle_http_status(response) }
        end

        private

        def http(uri)
          @http ||= Net::HTTP.new(uri.host, uri.port).tap do |instance|
            instance.use_ssl = uri.scheme == 'https'
            instance.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
        end

        def request_object(method, uri, request_body, headers)
          http_class_for(method)
            .new(uri.request_uri)
            .tap { |instance| headers.each { |key, value| instance[key.to_s] = value } }
            .tap { |instance| instance.body = request_body }
        end

        def http_class_for(method)
          case method
          when :head then Net::HTTP::Head
          when :get then Net::HTTP::Get
          when :post then Net::HTTP::Post
          when :patch then Net::HTTP::Patch
          when :put then Net::HTTP::Put
          when :delete then Net::HTTP::Delete
          end
        end

        def with_logging(uri)
          started_at = Time.now.to_f
          @logger&.call("Fetching #{uri}")
          result = yield
          @logger&.call("Fetched  #{uri} (#{Time.now.to_f - started_at} sec)")
          result
        end

        def handle_http_status(response)
          case response.code.to_i
          when 404 then nil
          when 400..499 then raise ClientError, response.body
          when 500..599 then raise ServerError, response.body
          else response.body
          end
        end
      end
    end
  end
end
