class MessagesController < ApplicationController
  def show_chat
    friend = User.find(params[:friend_id])
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update("chat-frame", partial: "messages/chat_box",
        locals: { friend: friend })
      }

      format.html { render partial: "messages/chat_box", locals: { friend: friend } }
    end
  end

  def close_chat
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update("chat-frame", "")
      }
      format.html { head :ok }
    end
  end
end
