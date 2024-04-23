# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user)
    visit new_user_session_url
    fill_in 'Eメール', with: @user.email
    fill_in 'パスワード', with: @user.password
    click_button 'ログイン'
  end

  test 'create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'title'
    fill_in '内容', with: 'content'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text 'title'
    assert_text 'content'
    assert_text @user.name
  end

  test 'show report' do
    report = FactoryBot.create(:report)
    visit report_url(report.id)

    assert_text report.title
    assert_text report.content
    assert_text report.user.name
  end

  test 'update report' do
    report = FactoryBot.create(:report, user: @user)
    visit report_url(report.id)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: 'title_updated'
    fill_in '内容', with: 'content_updated'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text 'title_updated'
    assert_text 'content_updated'
    assert_text @user.name
  end

  test 'delete report' do
    report = FactoryBot.create(:report, user: @user)
    visit report_url(report.id)
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
    assert_no_text report.title
    assert_no_text report.content
  end
end
