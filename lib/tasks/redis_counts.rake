namespace :redis_counts do
  desc "Update Redis counts for messages and chats"
  task update: :environment do
    # Fetch the latest counts of messages and chats from the database
    Application.find_each do |application|
      application.chats.find_each do |chat|
        chat_key = "chat:#{application.token}#{chat.id}:messages_count"
        latest_message_count = chat.messages.count

        # Set the Redis key with the latest message count
        $redis.set(chat_key, latest_message_count)
      end

      chat_key = "application:#{application.token}:chats_count"
      latest_chat_count = application.chats.count

      # Set the Redis key with the latest chat count
      $redis.set(chat_key, latest_chat_count)
    end
  end
end
