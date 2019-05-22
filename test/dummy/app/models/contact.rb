# frozen_string_literal: true

class Contact < ApplicationRecord
  include Jsonapi::Filter
  include Jsonapi::Sort

  # Sorting
  sortable_fields :last_name
  default_sort last_name: :desc

  # Filters
  filter :first_name, ->(value) { where(first_name: value) }
  scope :last_name, ->(value) { where(last_name: value) }
end
