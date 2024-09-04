# app/workers/update_counts_worker.rb

class UpdateCountsWorker
  include Sidekiq::Worker

  def perform
    Application.find_each do |application|
      application.chats.find_each do |chat|
        latest_message_count = chat.messages.count
        chat.update(messages_count: latest_message_count)
      end

      latest_chat_count = application.chats.count
      application.update(chats_count: latest_chat_count)
    end
  end
end
