GEM_NAME = "vk_longpoll_bot"

desc "Build gem file"
task :build do
  puts `gem build #{GEM_NAME}.gemspec`
end

desc "Uninstall gem"
task :uninstall do
  puts `gem uninstall #{GEM_NAME}`
end

desc "Build and install gem"
task :install_local => :build do
  puts `gem install ./#{GEM_NAME}-*.gem`
end

desc "Setup SSL certificate"
task :setup_ssl do
  print "Path to SSL certificate (leave empty if there is no troubles with SSL):"
  ssl_cert_path = STDIN.gets.chomp
  puts
  ENV["SSL_CERT_FILE"] = ssl_cert_path
end