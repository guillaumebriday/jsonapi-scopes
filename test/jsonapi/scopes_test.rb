# frozen_string_literal: true

require 'test_helper'

class Jsonapi::Scopes::Test < ActiveSupport::TestCase
  test 'truth' do
    assert_kind_of Module, Jsonapi::Scopes
  end
end
