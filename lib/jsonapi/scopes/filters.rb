# frozen_string_literal: true

module Jsonapi
  module Filter
    extend ActiveSupport::Concern

    included do
      @filters ||= []
    end

    module ClassMethods
      attr_reader :filters

      def filter(name, *args)
        scope("filter_#{name}", *args)
        @filters << name
      end

      def apply_filter(params)
        records = self
        filtering_params = params.dig(:filter) || {}

        filtering_params.each do |key, value|
          records = records.public_send("filter_#{key}", URI.decode(value)) if @filters.include?(key.to_sym)
        end

        records
      end
    end
  end
end
