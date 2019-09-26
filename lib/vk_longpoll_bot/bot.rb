module VkLongpollBot

  ##
  # Main class, which contains all the methods of bot.
  class Bot
  
    ##
    # @return [Integer] group ID.
    attr_reader :id

    ##
    # @return [Hash<Symbol, Array<EventListener>>] hash with listeners for each of event type.
    attr_reader :event_listeners
  
    ##
    # Initialize bot. This method don't start longpoll session.
    #
    # @param access_token [String] group access token.
    # @param group_id [Integer] group of associated ID.
    # @param options [Hash]
    #
    # @option options [Gem::Version, String] api_version (VK_API_URL_BASE) version of VK API.
    # @option options [Integer] longpoll_wait longpoll (LONGPOLL_STANDART_WAIT) requests timeout.
    def initialize(access_token, group_id, options = {})
      @event_listeners = Hash.new { |hash, key| hash[key] = Array.new }
      @on_start = []
      @on_finish = []
    
      @access_token = access_token.to_s
      @id = group_id.to_i
      
      @api_version = options[:api_version] || VK_API_CURRENT_VERSION
      @longpoll_wait = options[:longpoll_wait] || LONGPOLL_STANDART_WAIT
      
      @longpoll = {}
    end

    ##
    # @! group API methods
    
    ##
    # Call for API method.
    #
    # @param method_name ["String"] name of requested method. See https://vk.com/dev/methods
    #
    # @return [Hash]
    def api(method_name, parameters = {})
      Request.api(method_name, parameters, @access_token, @api_version)
    end
    
    ##
    # Send text message.
    #
    # @param target [Integer] ID of receiver.
    # @param content [String] text of message.
    # @param options [Hash] additional options which must be sent with request.
    #   Options +user_id+, +message+ and +random_id+ will be overwritten
    #
    # @return [Hash]
    def send_message(target, content, options = {})
      target_id = target.to_i
      forced_options = {
        user_id: target_id,
        message: content,
        random_id: Utility.random_id(target_id)
      }
      api("messages.send", options.merge(forced_options))
    end

    ##
    # Enable group online status
    #
    # @return [nil]
    def enable_online
      begin
        api("groups.enableOnline", group_id: @id)
      rescue
        # Online is already enabled
      end
      nil
    end

    ##
    # Disable group online status
    #
    # @return [nil]
    def disable_online
      begin
        api("groups.disableOnline", group_id: @id)
      rescue
        # Online is already disabled
      end
      nil
    end
    
    ##
    # @!endgroup

    ##
    # @!group Events
    
    ##
    # Add new event listener.
    #
    # @param options [Hash]
    #
    # @option options [String] subtype
    #
    # @yieldparam event [Event]
    # 
    # @return [nil]
    def on(options, &block)
      raise ArgumentError.new("Got subtype #{options[:subtype]} of class #{options[:subtype].class}") unless String === options[:subtype] && Events.valid_subtype?(options[:subtype])
      @event_listeners[options[:subtype]] << Events::EventListener.new(options, &block)
      nil
    end
    
    ##
    # Add code to be executed right after bot starts.
    def on_start(&block)
      @on_start << block
    end
    
    ##
    # Add code to be executed right after bot finishes.
    def on_finish(&block)
      @on_finish << block
    end

    ##
    # @!endgroup
    
    ##
    # Start bot. This methods freeze current thread until {Bot#stop} method is called.
    #
    # @return [void]
    def run
      @on_start.each(&:call)
    
      init_longpoll
      run_longpoll
      
      @on_finish.each(&:call)
    end
    
    ##
    # Stop bot.
    #
    # @return [void]
    def stop
      @finish_flag = true
    end
    

    private
    
    # Request longpoll data.
    def init_longpoll
      lp = api("groups.getLongPollServer", group_id: @id)
      @longpoll[:server] = lp["server"]
      @longpoll[:key] = lp["key"]
      @longpoll[:ts] = lp["ts"]    
    end
    
    # Start longpoll. Requires +init_longpoll+ to be run first.
    def run_longpoll
      @finish_flag = false # Setting up flag for loop
      
      until @finish_flag
        response = Request.longpoll(@longpoll[:server], @longpoll[:key], @longpoll[:ts], @longpoll_wait)
        if response["failed"]
          Utility.warn "Longpoll failed with code #{response["failed"]}. This must be solvable. Keep running..."
          case response["failed"]
            when 1
              # Just update ts
              @longpoll[:ts] = response["ts"]
            when 2, 3
              # Need to reconnect
              init_longpoll
          else
            raise Exceptions::LongpollError("Unknown 'failed' value: #{response["failed"]}. Full response: #{response.to_s}")
          end
        elsif response["ts"] && response["updates"]
          # Everything is fine. Handling update
          @longpoll[:ts] = response["ts"]
          updates = response["updates"]
          response["updates"].each { |update| update_handler(update) }
        else
          raise Exceptions::LongpollError("Strange longpoll response: #{response.to_s}")
        end
      end
    end
    
    # Handle update from longpoll.
    def update_handler(update)
      event = Events::Event.new(update["type"], update["object"], update["group_id"], self)
      @event_listeners[event.subtype].each do |listener|
        # NOTE: If we had any attributes, we would check whether matching here.
        Thread.new(event) { |e| listener.call(e) }
      end
    end
    
  end

end
