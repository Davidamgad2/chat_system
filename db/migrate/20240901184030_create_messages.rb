class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.integer :number, default: 1
      t.text :body

      t.timestamps
    end
    add_index :messages, :number
  end
end
