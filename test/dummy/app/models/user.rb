# frozen_string_literal: true

class User < ApplicationRecord
  include Jsonapi::Include

  belongs_to :contact
  has_many :posts

  allowed_includes 'contact', 'posts.contact.users', 'posts', 'posts.user'
end
