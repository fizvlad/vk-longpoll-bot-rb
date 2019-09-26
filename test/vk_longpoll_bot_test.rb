require "test_helper"

class VkLongpollBotTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil VkLongpollBot::VERSION
  end
end
