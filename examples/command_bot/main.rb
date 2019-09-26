$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)

require "vk_longpoll_bot"
include VkLongpollBot

PREFIX = ">"

bot = Bot.new(ARGV[0], ARGV[1], api_version: "5.74")

bot.on_start do
  puts "Starting bot."
  bot.enable_online
end
bot.on_finish do
  puts "Finishing bot."
  bot.disable_online
end

bot.on(subtype: "message_new") do |event|
  puts "Got message from #{event["user_id"]}: #{event["body"].chomp}"
  next unless event["body"].start_with?(PREFIX)
  command = event["body"].chomp.sub(PREFIX, "")

  case command
    when "help"
      bot.send_message(event["user_id"], "Available commands: \n* help - show this message\n* answer - answer message\n* exit, stop - shut down")
    when "answer"
      bot.send_message(event["user_id"], "Answering")
    when "exit", "stop"
      bot.send_message(event["user_id"], "Shutting down")
      bot.stop
  else
    bot.send_message(event["user_id"], "Unknwon command")
  end
end

bot.run
