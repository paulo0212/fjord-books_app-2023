# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :report
  belongs_to :mentioned_report, class_name: 'Report'
end
