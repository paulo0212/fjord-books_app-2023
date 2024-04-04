# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :active_mentions, class_name: 'Mention', dependent: :destroy
  has_many :passive_mentions, class_name: 'Mention', foreign_key: 'mentioning_report_id', inverse_of: :mentioning_report, dependent: :destroy
  has_many :mentioning_reports, through: :active_mentions, source: :mentioning_report
  has_many :mentioned_reports, through: :passive_mentions, source: :report

  validates :title, presence: true
  validates :content, presence: true

  after_create do
    mentioning_report_ids = extract_mentioning_report_ids
    add_mentions(mentioning_report_ids)
  end

  after_update do
    existing_ids = mentioning_report_ids
    mentioning_ids = extract_mentioning_report_ids
    report_ids_to_add = existing_ids - mentioning_ids
    add_mentions(report_ids_to_add)
    report_ids_to_remove = mentioning_ids - existing_ids
    remove_mentions(report_ids_to_remove)
  end

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def add_mentions(mentioning_report_ids)
    return if mentioning_report_ids.none?

    mentioning_report_ids.each do |mentioning_report_id|
      active_mentions.create(mentioning_report_id:)
    end
  end

  def remove_mentions(mentioning_report_ids)
    return if mentioning_report_ids.none?

    mentioning_report_ids.each do |mentioning_report_id|
      active_mentions.find_by(mentioning_report_id:).destroy
    end
  end

  private

  def extract_mentioning_report_ids
    regexp = %r{http://localhost:3000/reports/(?<report_id>\d+)}
    content.scan(regexp).flatten.uniq.map(&:to_i)
  end
end
