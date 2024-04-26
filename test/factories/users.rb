# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test-user-#{n}@example.com" }
    password { 'password' }
    sequence(:name) { |n| "test-user-#{n}" }
  end
end
