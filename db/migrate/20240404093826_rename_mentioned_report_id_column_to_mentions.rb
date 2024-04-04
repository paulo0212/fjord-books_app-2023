class RenameMentionedReportIdColumnToMentions < ActiveRecord::Migration[7.0]
  def change
    remove_index :mentions, column: [:report_id, :mentioned_report_id]
    rename_column :mentions, :mentioned_report_id, :mentioning_report_id
    add_index :mentions, [:report_id, :mentioning_report_id], unique: true
  end
end
