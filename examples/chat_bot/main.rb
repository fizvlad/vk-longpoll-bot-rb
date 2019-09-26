$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)

require "vk_longpoll_bot"
include VkLongpollBot

bot = Bot.new(ARGV[0], ARGV[1])

bot.on_start { puts "Starting bot." }
bot.on_finish { puts "Finishing bot." }

bot.on(subtype: "message_typing_state") do |event|
  puts "#{event["from_id"]} is typing message"
end

bot.on(subtype: "message_new") do |event|
  puts "Got message from #{event["user_id"]}: #{event["body"]}"
  bot.send_message(event["user_id"], "I got your message")
  
  if event["attachments"]
    puts "And it got attachments! #{event["attachments"]}"
  end
  
  if event["body"].chomp == "stop"
    bot.send_message(event["user_id"], "Shutting down")
    bot.stop
  end
end

bot.run
