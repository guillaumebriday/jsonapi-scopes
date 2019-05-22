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
          records = records.public_send(key, value) if @filters.include?(key.to_sym)
        end

        records
      end
    end
  end
end
