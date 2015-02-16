class CreateDigupLog < ActiveRecord::Migration

  def self.up
    create_table :digup_logs do |t|
      t.string :cursor_info
      t.string :message
      t.references :request_response_info
      t.datetime :date
    end
  end

  def self.down
    remove_table :digup_logs
  end

end
