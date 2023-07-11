class AddStatusToSmsMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :sms_messages, :status, :text
  end
end
