# frozen_string_literal: true

module Seibii
  module Http
    module Clients
      class Json
        def initialize(logger: nil)
          @base = Base.new(logger: logger)
        end

        def request(method:, uri:, params: nil, headers: {})
          response_body = @base.request(
            method: method,
            uri: uri,
            request_body: params&.yield_self { |p| Oj.dump(p, mode: :compat) },
            headers: headers.merge('Accept': 'application/json', 'Content-Type': 'application/json')
          )
          Oj.load(response_body, mode: :compat, symbol_keys: true)
        end
      end
    end
  end
end
