module VkLongpollBot

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
      (rand(1000) * target_id * Time.now.to_f * 1000).to_i % 2**32
    end
    
  end

end
