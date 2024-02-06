# frozen_string_literal: true

module Jsonapi
  module Filter
    extend ActiveSupport::Concern

    included do
      @filters ||= []
    end

    module ClassMethods
      def filter(name, *args)
        scope(name, *args)
        @filters << name
      end

      def apply_filter(params)
        records = all
        filtering_params = params.dig(:filter) || {}

        filtering_params.each do |key, value|
          value = value.to_s.split(',').reject(&:blank?) if value.include?(',')
          value = value.join if value.is_a? Array

          raise InvalidAttributeError, "#{key} is not valid as filter attribute." unless @filters.include?(key.to_sym)

          records = records.public_send(key, value)
        end

        records
      end
    end
  end
end
