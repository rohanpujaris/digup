class CreateRequestResponseInfo < ActiveRecord::Migration

  def self.up
    create_table :request_response_infos do |t|
      t.string :request_method
      t.string :request_accepts
      t.string :response_type
      t.string :response_status
      t.string :params
      t.timestamps
    end
  end

  def self.down
    remove_table :digup_logs
  end

end
