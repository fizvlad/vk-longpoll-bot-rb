Gem::Specification.new do |s|
  s.name           = "vk_chat_bot"
  s.summary        = "Provides interface to create simple VK chat bot"
  s.description    = "Library to work with VK API and create simple chat bot for group."
  s.version        = "0.0.1"
  s.author         = "Kuznetsov Vladislav"
  s.email          = "fizvlad@mail.ru"
  s.homepage       = "https://github.com/fizvlad/vk-chat-bot-rb"
  s.platform       = Gem::Platform::RUBY
  s.required_ruby_version = ">=2.3.1"
  s.files          = Dir[ "lib/**/**", "test/**/**", "LICENSE", "Rakefile", "README.md", "vk_chat_bot.gemspec" ]
  s.test_files     = Dir[ "test/test*.rb" ]
  s.license        = "MIT"

  s.add_runtime_dependency "rake",      "~>12.3"
  s.add_runtime_dependency "json",      "~>2.2"
end