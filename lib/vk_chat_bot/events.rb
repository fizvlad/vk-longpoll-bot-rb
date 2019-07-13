module VkChatBot

  # Everything related to longpoll events.
  module Events
    
    # All the types and subtypes of events
    TYPES = {
      message: [:message_new, :message_reply, :message_edit, :message_allow, :message_deny],
      photo:   [:photo_new, :photo_comment_new, :photo_comment_edit, :photo_comment_restore, :photo_comment_delete],
      audio:   [:audio_new],
      video:   [:video_new, :video_comment_new, :video_comment_restore, :video_comment_delete],
      wall:    [:wall_post_new, :wall_repost, :wall_reply_new, :wall_reply_edit, :wall_reply_restore, :wall_reply_delete],
      board:   [:board_post_new, :board_post_edit, :board_post_restore, :board_post_delete],
      market:  [:market_comment_new, :market_comment_edit, :market_comment_restore, :market_comment_delete],
      group:   [:group_leave, :group_join, :group_officers_edit, :group_change_settings, :group_change_photo],
      user:    [:user_block, :user_unblock],
      poll:    [:poll_vote_new],
      vkpay:   [:vkpay_transaction],
      app:     [:app_payload]
    }
  
    # Class containing data recieved from longpoll. Provides easy update to it's data.
    class Event
    
      attr_reader :subtype, :group_id
      
      # Initialize from fields of update json.
      def initialize(subtype, object, group_id)
        @subtype = subtype
        @object = object
        @group_id = group_id
      end
      
      # Provides access to fields of update object.
      def [](arg)
        @object[arg.to_s]
      end
      
      # TODO
    
    end
    
    # NOTE: It might be better to create separate class for each event but there's lot of them and they don't have good hierarchy.
    
    # Class containing block to run on some event.
    class EventListener
    
      attr_reader :subtype
      
      def initialize(attributes, &block)
        @subtype = attributes[:subtype]
        @block = block
        
        # TODO
      end
    
      # TODO
    
    end
    
  end

end