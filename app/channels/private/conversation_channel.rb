# frozen_string_literal: true

class Private::ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "private_conversations_#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
  end

  def send_message(data)
    message_params = data['message'].each_with_object({}) do |el, hash|
      hash[el['name']] = el['value']
    end
    Private::Message.create(message_params)
            
    #track this on activities table
    conversation = Private::Conversation.where(id: message_params['conversation_id']).first   
    @is_user_sender = message_params['user_id'].to_s == conversation.sender_id.to_s
    
    if @is_user_sender
        userDetails = User.where(id: conversation.recipient_id).first 
    else
        userDetails = User.where(id: conversation.sender_id).first      
    end    
    
    activity_description = 'New message between '+ current_user.name + ' - ' +  userDetails.name
        
    Activity.create(name: "New message", description: activity_description, activity_type: 'message')
  end
  
  def set_as_seen(data)
    # find a conversation and set its all unseen messages as seen
    conversation = Private::Conversation.find(data["conv_id"].to_i)
    messages = conversation.messages.where(seen: false)
    messages.each do |message|
      message.update(seen: true)
    end
  end
end