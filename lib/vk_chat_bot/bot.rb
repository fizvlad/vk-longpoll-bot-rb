module VkChatBot

  # Main class, which contains all the methods of bot.
  class Bot
  
    # Every bot stores id of group it operates.
    attr_reader :id
  
    # Initialize bot. This method don't run longpoll.
    #
    # <tt>options</tt> hash can contain following keys:
    # * <tt>:api_version</tt> - version of api to use
    # * <tt>:longpoll_wait</tt> - longpoll requests timeout
    def initialize(access_token, id, options = {})
      @event_listeners = Hash.new([])
      @on_start = []
      @on_finish = []
    
      @access_token = access_token      
      @id = id
      
      @api_version = options[:api_version] || VK_API_CURRENT_VERSION
      @longpoll_wait = options[:longpoll_wait] || LONGPOLL_STANDART_WAIT
      
      @longpoll = {}
      
      # TODO
    end
    
    # Call for api method with given parameters.
    def api(method_name, parameters = {})
      Request.api(method_name, parameters, @access_token, @api_version)
    end
    
    # Messaging
    
    # Send message to <tt>target</tt> with provided <tt>content</tt>.
    def send_message(target, content)
      case target
        when User
          target_id = target.id
      else
        target_id = target.to_i
      end
      
      api("messages.send", user_id: target_id, message: content, random_id: Utility.random_id(target_id))
    end
    
    # TODO: Which methods are also addable here?
    
    # Events
    
    # Add event listener.
    # 
    # <tt>attributes</tt> hash can contain following keys:
    # * <tt>:subtype</tt> - event subtype. All of event types and subtypes are stated in Events::TYPES
    def on(attributes, &block)
      raise ArgumentErrror unless Events::TYPES.value?(attributes[:subtype])
      @event_listeners[attributes[:subtype]] << EventListener.new(attributes, &block)
    end
    
    # Add code to be executed right after bot starts.
    def on_start(&block)
      @on_start << block
    end
    
    # Add code to be executed right after bot finishes.
    def on_finish(&block)
      @on_finish << block
    end
    
    # Running bot
    
    # Start bot. This methods freeze current thread until <tt>stop</tt> called.
    def run
      @on_start.each(&:call)
    
      init_longpoll
      run_longpoll
      
      @on_finish.each(&:call)
    end
    
    # Stop bot.
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
    
    # Start longpoll. Requires <tt>init_longpoll</tt> to be run first.
    def run_longpoll
      @finish_flag = false # Setting up flag for loop
      
      until @finish_flag
        response = Request.longpoll(@longpoll[:server], @longpoll[:key], @longpoll[:ts], @longpoll_wait) # TODO
        if response["failed"]
          # Error happened
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
      event = Event.new(update["type"], update["object"], update["group_id"])
      # TODO
    end
    
  end

end