class CreateChatWorker
  include Sidekiq::Worker

  def perform(application_token, chat_number)
    # Increment the message count in Redis
    application = Application.find_by(token: application_token)
    # Create the message in the database
    Chat.create!(
      application_id: application.id,
      number: chat_number,
    )
  end
end
