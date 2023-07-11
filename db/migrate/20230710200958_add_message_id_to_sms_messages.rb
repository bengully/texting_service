class AddMessageIdToSmsMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :sms_messages, :message_id, :text
  end
end
