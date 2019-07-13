module VkChatBot

  # Module with some utility methods.
  module Utility
  
    # Log warning.
    def self.warn(msg)
      if defined?(Warning.warn)
        Warning.warn msg
      else
        STDERR.puts "Warning: #{msg}"
      end
    end

    # Generate <tt>random_id</tt> for message.
    def self.random_id(target_id)
      (rand(100) * target_id) % 2**32
    end
    
  end

end