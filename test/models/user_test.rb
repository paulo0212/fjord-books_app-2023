# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # name_or_email
  test 'returns name if user has name' do
    user = FactoryBot.create(:user, name: 'TestTaro')
    assert_equal 'TestTaro', user.name_or_email
  end

  test 'returns email if name is blank' do
    user = FactoryBot.create(:user, name: '', email: 'testaro@example.com')
    assert_equal 'testaro@example.com', user.name_or_email
  end
end
