class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.integer :report_id
      t.integer :mentioned_report_id

      t.timestamps
    end
    add_index :mentions, [:report_id, :mentioned_report_id], unique: true
  end
end
