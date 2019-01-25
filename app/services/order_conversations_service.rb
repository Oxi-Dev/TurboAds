# frozen_string_literal: true

class OrderConversationsService
  def initialize(params)
    @user = params[:user]
  end

  # get and order conversations by last messages' dates in descending order
  def call
    all_private_conversations = Private::Conversation.all_by_user(@user.id)
                                                     .includes(:messages)
    all_conversations = all_private_conversations.sort do |a, b|
      b.messages.last.created_at <=> a.messages.last.created_at
    end
  end
end
