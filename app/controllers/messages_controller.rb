class MessagesController < ApplicationController
  def turbo_respond(to_user)
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update("chat-frame", partial: "messages/chat_box",
        locals: { friend: to_user })
      }

      format.html { render partial: "messages/chat_box", locals: { friend: to_user } }
    end
  end

  def show_chat
    to_user = User.find(params[:friend_id])
    turbo_respond(to_user)
  end

  def close_chat
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update("chat-frame", "")
      }
      format.html { head :ok }
    end
  end

  def create
    from = current_user
    to = User.find(params[:to_user_id])
    text = params[:text]

    unless from && to && text.present?
      redirect_to root_path, alert: "Message not formatted well."
    end

    @message = Message.new(text:, from:, to:)

    if @message.save
      turbo_respond(to)
    else
      redirect_to root_path, alert: @message.errors.full_messages.to_sentence
    end
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end
end
