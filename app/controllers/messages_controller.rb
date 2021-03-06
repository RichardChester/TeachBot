# handle logic of the messages of the users' chats
class MessagesController < ApplicationController
  before_action :authenticate_user!
  include MessagesHelper
  include Services::UseCases::Message::CreateMessageService

  # handle modal window of sending new message to user
  def create
    # I'm not sure about this approach to organize code with hexagonal.
    # Hexagonal fit very well with one single model,
    # but when more than one, classic examples actually don't work very well
    create_message = CreateMessage.new(self)
    create_message.assign_recipient(params[:user_id])
    @chat = create_message.set_chat_between_users(current_user)
    @message = create_message.assign_message(current_user, message_params)
    create_message.create
  end

  # POST - mark message as red for auth user
  # @return [JSON]
  def mark_as_read
    message = fetch_cache(Message, params[:id])
    return fail_response(['Message not found'], 404) unless message
    chat_id = message.chat_id
    current_user.unread_messages.delete(message)
    UnreadMessagesChannel.remove_message(current_user, chat_id, message.id)
    render json: { status: 'done' }, status: 200
  end

  # POST - mark all unread messages as read for current_user
  # @return [Object]
  def mark_all_as_read
    messages = current_user.unread_messages.where(chat_id: params[:chat_id])
    current_user.unread_messages.delete(messages)
    render json: { status: 'done' }, status: 200
  end

  # POST - return all user's unread messages
  # @return [Array]
  def unread_messages
    chat_id = params[:chat_id]
    @messages = chat_unread_messages(current_user, chat_id)
  end

  # POST - return user's unread messages count
  # @return [Object]
  def unread_messages_count
    count = current_user.unread_messages.count
    render json: { count: count }
  end

  # sends notification about new chat to recipient
  # @param [Chat] chat
  def send_new_chat_notification(chat)
    recipient = chat.recipient
    notification = Notification.new_chat(chat, current_user)
    recipient.attach_notification(notification)
    NotificationsChannel.broadcast_notification_to(recipient, notification)
  end

  # save message and send message through Cable
  # @param [Chat] chat
  # @param [Message] message
  def send_message(chat, message)
    ChatChannel.send_message(chat.id, message)
    broadcast_new_unread_message(chat.members, current_user)
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end
end
