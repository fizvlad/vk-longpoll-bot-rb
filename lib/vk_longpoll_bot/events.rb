module VkLongpollBot

  ##
  # Everything related to longpoll events.
  module Events
    
    ##
    # All the types and subtypes of events.
    TYPES = {
      message: %w{message_new message_reply message_edit message_typing_state message_allow message_deny},
      photo:   %w{photo_new photo_comment_new photo_comment_edit photo_comment_restore photo_comment_delete},
      audio:   %w{audio_new},
      video:   %w{video_new video_comment_new video_comment_edit video_comment_restore video_comment_delete},
      wall:    %w{wall_post_new wall_repost wall_reply_new wall_reply_edit wall_reply_restore wall_reply_delete},
      board:   %w{board_post_new board_post_edit board_post_restore board_post_delete},
      market:  %w{market_comment_new market_comment_edit market_comment_restore market_comment_delete},
      group:   %w{group_leave group_join group_officers_edit group_change_settings group_change_photo},
      user:    %w{user_block user_unblock},
      poll:    %w{poll_vote_new},
      vkpay:   %w{vkpay_transaction},
      app:     %w{app_payload}
    }
    
    ##
    # Check whether subtype is correct.
    #
    # @param subtype [String]
    def self.valid_subtype?(subtype)
      TYPES.values.any? { |arr| arr.include?(subtype) }
    end
  
    ##
    # Class containing data received from longpoll. Provides easy access to it's data.
    class Event
    
      ##
      # @return [String] subtype of event.
      attr_reader :subtype

      ##
      # @return [Integer] ID of group which received event.
      attr_reader :group_id

      ##
      # @return [Hash] hash with updates data.
      attr_reader :data

      ##
      # @return [Bot] longpoll bot which received event.
      attr_reader :bot
      
      ##
      # New event. Initialize from fields of update json and bot which got this event.
      #
      # @param subtype [String]
      # @param data [Hash] +update+ array entry.
      # @param group_id [Integer]
      # @param bot [Bot]
      def initialize(subtype, data, group_id, bot)
        @subtype = subtype.to_s
        @data = data
        @group_id = group_id.to_i
        @bot = bot
      end
      
      ##
      # Provides access to fields of update data.
      #
      # @param arg [String] hash key.
      #
      # @return [Object]
      def [](arg)
        @data[arg.to_s]
      end
    
    end
    
    # NOTE: It might be better to create separate class for each event but there's lot of them and they don't have good hierarchy.
    
    ##
    # Class containing block to run on some event.
    class EventListener
    
      ##
      # @return [String] subtype of this listener.
      attr_reader :subtype
      
      ##
      # Initialize new listener
      #
      # @param options[Hash]
      #
      # @option options [String] subtype
      #
      # @yieldparam event [Event]
      def initialize(options, &block)
        @subtype = options[:subtype]
        @block = block
      end
      
      ##
      # Calls block with given event as argument.
      #
      # @param event [Event]
      #
      # @return [void]
      def call(event)
        @block.call(event)
      end
    
    end
    
  end

  ##
  # Alias for {Events::Event} class
  Event = Events::Event

  ##
  # Alias for {Events::EventListener} class
  EventListener = Events::EventListener

end
