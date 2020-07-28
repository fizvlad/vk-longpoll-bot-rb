lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vk_longpoll_bot/version"

Gem::Specification.new do |spec|
  spec.name          = "vk_longpoll_bot"
  spec.version       = VkLongpollBot::VERSION
  spec.authors       = ["Fizvlad"]
  spec.email         = ["fizvlad@mail.ru"]

  spec.summary       = "Provides interface to create simple VK longpoll bot"
  spec.description   = "Library to work with VK API and create simple longpoll bot for group."
  spec.homepage      = "https://github.com/fizvlad/vk-longpoll-bot-rb"
  spec.license       = "MIT"

  spec.required_ruby_version = ">=2.3.1"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fizvlad/vk-longpoll-bot-rb"
  spec.metadata["changelog_uri"] = "https://github.com/fizvlad/vk-longpoll-bot-rb/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "json", ">= 2.2", "< 2.4"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
