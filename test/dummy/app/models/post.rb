# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_one :contact, through: :user
end
