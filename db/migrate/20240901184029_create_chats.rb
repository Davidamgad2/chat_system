class CreateChats < ActiveRecord::Migration[7.2]
  def change
    create_table :chats do |t|
      t.references :application, null: false, foreign_key: true
      t.integer :number, default: 1
      t.integer :messages_count, default: 0

      t.timestamps
    end
    add_index :chats, :number
  end
end
