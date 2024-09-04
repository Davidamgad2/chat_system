class CreateMessageWorker
  include Sidekiq::Worker

  def perform(application_id, chat_id, chat_number, message_body, message_number)
    # Create the message in the database
    Message.create!(
      chat_id: chat_id,
      number: message_number,
      body: message_body,
    )
  end
end
