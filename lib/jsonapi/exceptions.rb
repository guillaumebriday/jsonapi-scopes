# frozen_string_literal: true

module Jsonapi
  class Error < StandardError; end

  class InvalidAttributeError < Error
    def initialize(message)
      super(message)
    end
  end
end
