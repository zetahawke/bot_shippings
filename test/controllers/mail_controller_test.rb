require 'test_helper'

class MailControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mail_index_url
    assert_response :success
  end

end
