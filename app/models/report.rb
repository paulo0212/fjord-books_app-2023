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

  after_create do
    mentioned_report_ids = extract_mentioning_report_ids
    add_mentions(mentioned_report_ids)
  end

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def add_mentions(mentioned_report_ids)
    mentioned_report_ids.each do |mentioned_report_id|
      active_mentions.create(mentioned_report_id:)
    end
  end

  private

  def extract_mentioning_report_ids
    regexp = %r{http://localhost:3000/reports/(?<report_id>\d+)}
    content.scan(regexp).flatten.uniq.map(&:to_i)
  end
end
