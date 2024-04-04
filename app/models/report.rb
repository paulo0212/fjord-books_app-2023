# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :active_mentions, class_name: 'Mention', dependent: :destroy
  has_many :passive_mentions, class_name: 'Mention', foreign_key: 'mentioned_report_id', inverse_of: :mentioned_report, dependent: :destroy
  has_many :mentioning_reports, through: :active_mentions, source: :mentioned_report
  has_many :mentioned_reports, through: :passive_mentions, source: :report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
