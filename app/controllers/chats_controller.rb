class ChatsController < ApplicationController
  def index
    application = Application.find_by(token: params[:application_token])
    chats = Chat.where(application_id: application.id)
    if !chats
      render json: [], status: :not_found
    else
      render json: chats
    end
  end

  def show
    @application = Application.find_by(token: params[:application_token])
    @chat = Chat.find_by(application_id: @application.id, number: params[:number])
    if @chat
      render json: @chat
    else
      render json: [], status: :not_found
    end
  end

  def create
    application_token = params[:application_token]

    chat_key = "application:#{application_token}:chats_count"

    # Fetch the current message count from Redis
    chat_count = $redis.get(chat_key).to_i + 1
    chat_number = $redis.incr(chat_key)

    # Enqueue the job to create the message
    CreateChatWorker.perform_async(application_token, chat_number)

    render json: { current_message_count: chat_count }, status: :created
  end
end
