require "net/http"
require "json"

module VkLongpollBot

  ##
  # Some functions to send HTTP requests.
  module Request
  
    ##
    # Regular GET HTTP request to given URI.
    #
    # @param url [String]
    #
    # @return [String]
    def self.to(url)
      uri = URI(url.to_s)
      Net::HTTP.get(uri)
    end
    
    ##
    # GET request to VK API.
    #
    # @param method_name [String, Symbol]
    # @param parameters [Hash]
    # @param access_token [String]
    # @param v [Gem::Version, String] VK API version.
    #
    # @return [Hash]
    def self.api(method_name, parameters, access_token, v = VK_API_CURRENT_VERSION)
      response = JSON.parse self.to("#{VK_API_URL_BASE}/method/#{method_name}?access_token=#{access_token}&v=#{v.to_s}&#{URI.encode_www_form(parameters)}")
      if response["response"]
        response["response"]
      elsif response["error"]
        raise Exceptions::APIError.new(response)
      else
        raise Exceptions::ResponseError.new(response)
      end
    end
    
    ##
    # GET request to longpoll server.
    #
    # @param server [String] server address.
    # @param key [String] secret session key.
    # @param ts [Integer] index of last event.
    # @param wait [Integer] size of request timeout in seconds.
    #
    # @return [Hash] hash with timestamp of last event and array of updates.
    def self.longpoll(server, key, ts, wait = LONGPOLL_STANDART_WAIT)
      JSON.parse self.to("#{server}?act=a_check&key=#{key}&ts=#{ts}&wait=#{wait}")
    end
  
  end

end
