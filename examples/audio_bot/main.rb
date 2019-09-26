$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)

require "vk_music" # See https://rubygems.org/gems/vk_music

require "vk_longpoll_bot"
include VkLongpollBot

bot = Bot.new(ARGV[0], ARGV[1])

bot.on_start { puts "Starting bot." }
bot.on_finish { puts "Finishing bot." }

bot.on(subtype: "message_new") do |event|
  next unless event["attachments"] && event["body"].chomp == "id"
  reply = []
  event["attachments"].each do |att|
    if att["type"] == "audio"
      audio = VkMusic::Audio.new(
        artist: att["audio"]["artist"],
        id: att["audio"]["id"],
        owner_id: att["audio"]["owner_id"],
        title: att["audio"]["title"],
        url: att["audio"]["url"],
        duration: att["audio"]["duration"]
      )
      
      puts audio
      reply << "#{audio.owner_id}_#{audio.id}"
    end
  end
  
  bot.send_message(event["user_id"], reply.join("\n")) unless reply.empty?
end

bot.on(subtype: "message_new") do |event|
  if event["body"].chomp == "stop"
    bot.send_message(event["user_id"], "Shutting down")
    bot.stop
  end
end

bot.run
