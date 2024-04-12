class AddForeignKeyToMentions < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :mentions, :reports, column: :report_id
    add_foreign_key :mentions, :reports, column: :mentioning_report_id
    change_column_null :mentions, :report_id, false
    change_column_null :mentions, :mentioning_report_id, false
    add_index(:mentions, :report_id, name: 'index_mentions_on_report_id')
    add_index(:mentions, :mentioning_report_id, name: 'index_mentions_on_mentioning_report_id')
  end
end
