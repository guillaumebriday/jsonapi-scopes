require "jsonapi/scopes/railtie"

module Jsonapi
  module Scopes
    extend ActiveSupport::Concern

    included do
      @filters ||= []
    end

    module ClassMethods
      attr_reader :filters

      def filter(name, *args)
        scope(name, *args)
        @filters << name
      end

      def apply_filter(params)
        results = self
        filtering_params = params.dig(:filter) || {}

        filtering_params.each do |key, value|
          results = results.public_send(key, value) if value.present? && @filters.include?(key.to_sym)
        end

        results
      end
    end
  end
end
