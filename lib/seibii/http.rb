# frozen_string_literal: true

require 'net/http'
require 'oj'
require 'seibii/http/clients'
require 'seibii/http/version'

module Seibii
  module Http
    class ClientError < StandardError
      attr_reader :response

      def initialize(response)
        super
        @response = response
      end
    end

    class ServerError < StandardError
      attr_reader :response

      def initialize(response)
        super
        @response = response
      end
    end
  end
end
