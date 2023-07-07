class CreateSmsMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :sms_messages do |t|
      t.text :phone_number
      t.text :message

      t.timestamps
    end
  end
end
