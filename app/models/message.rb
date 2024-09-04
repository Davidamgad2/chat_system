# app/models/message.rb
class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :chat

  settings index: { number_of_shards: 1 } do
    mappings dynamic: "false" do
      indexes :body, type: :text
      indexes :chat_id, type: :integer
      indexes :created_at, type: :date
      indexes :updated_at, type: :date
    end
  end

  def as_indexed_json(options = {})
    as_json(
      only: [:body, :chat_id, :created_at, :updated_at],
    )
  end
end

# Create the index and import existing records
Message.__elasticsearch__.create_index!
Message.import
