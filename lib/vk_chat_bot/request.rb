require "net/http"
require "json"

module VkChatBot

  # Some functions to send HTTP requests
  module Request
  
    # Regular HTTP request to given URI.
    def self.to(url)
      uri = URI(url.to_s)
      Net::HTTP.get(uri)
    end
    
    # Request to api.
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
    
    # Request to longpoll server.
    def self.longpoll(server, key, ts, wait = LONGPOLL_STANDART_WAIT)
      JSON.parse self.to("#{server}?act=a_check&key=#{key}&ts=#{ts}&wait=#{wait}")
    end
  
  end

end