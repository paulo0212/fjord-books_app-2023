# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    association :user
    title { 'Hello, World!' }
    content { 'This is my report.' }
  end
end
