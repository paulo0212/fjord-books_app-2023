# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # editable?
  test 'user who created a report can edit the report' do
    report = FactoryBot.create(:report)
    user = report.user
    assert report.editable?(user)
  end

  test 'users who did not create a report cannot edit the report' do
    report = FactoryBot.create(:report)
    other_user = FactoryBot.create(:user)
    assert_not report.editable?(other_user)
  end

  # created_on
  test 'returns date of the report created' do
    report = FactoryBot.create(:report)
    report.created_at = Time.zone.local(2000, 1, 1, 12, 34)
    assert_equal Date.new(2000, 1, 1), report.created_on
  end

  # save_mentions
  def setup_for_save_mentions
    @mentioned_by = FactoryBot.create(:report)
    @mention_to = FactoryBot.create(:report, content: "http://localhost:3000/reports/#{@mentioned_by.id}")
  end

  test 'create report_mentions if reports are mentioned' do
    setup_for_save_mentions
    assert_equal @mentioned_by, ReportMention.find_by(mention_to_id: @mention_to.id).mentioned_by
  end

  test 'update report_mentions if mentioned reports are updated' do
    setup_for_save_mentions
    assert_equal @mentioned_by, ReportMention.find_by(mention_to_id: @mention_to.id).mentioned_by

    new_mentioned_by = FactoryBot.create(:report)
    Report.find(@mention_to.id).update(content: "http://localhost:3000/reports/#{new_mentioned_by.id}")
    assert_equal new_mentioned_by, ReportMention.find_by(mention_to_id: @mention_to.id).mentioned_by
  end

  test 'destroy report_mentions if no reports are mentioned' do
    setup_for_save_mentions
    assert_equal @mentioned_by, ReportMention.find_by(mention_to_id: @mention_to.id).mentioned_by

    Report.find(@mention_to.id).update(content: 'Hello, World!')
    assert_nil ReportMention.find_by(mention_to_id: @mention_to.id)
  end

  test 'does not create report_mentions of the report created itself' do
    setup_for_save_mentions
    assert_equal @mentioned_by, ReportMention.find_by(mention_to_id: @mention_to.id).mentioned_by

    Report.find(@mention_to.id).update(content: "http://localhost:3000/reports/#{@mention_to.id}")
    assert_nil ReportMention.find_by(mention_to_id: @mention_to.id)
  end
end
