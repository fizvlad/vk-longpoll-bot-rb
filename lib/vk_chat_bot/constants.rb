module VkChatBot

  # Base of URL to API.
  VK_API_URL_BASE = "https://api.vk.com"
  
  # It's recommended to use last version of VK API.
  VK_API_CURRENT_VERSION = Gem::Version.new("5.101")
  
  # Longpoll requests timeout.
  LONGPOLL_STANDART_WAIT = 25

end