module VkLongpollBot

  ##
  # Some utility methods.
  module Utility
  
    ##
    # Log warning message.
    def self.warn(msg)
      if defined?(Warning.warn)
        Warning.warn msg
      else
        STDERR.puts "Warning: #{msg}"
      end
    end

    ##
    # Generate +random_id+ for message.
    # 
    # This method generates random numerical ID based on current time, receiver ID and random salt.
    #
    # @param target_id [Integer] ID of message receiver.
    #
    # @return [Integer]
    def self.random_id(target_id)
      (rand(1000) * target_id * Time.now.to_f * 1000).to_i % 2**32
    end
    
  end

end
