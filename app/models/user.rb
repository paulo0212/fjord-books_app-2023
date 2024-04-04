# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :icon do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :preview, resize_to_limit: [50, 50]
  end
end
