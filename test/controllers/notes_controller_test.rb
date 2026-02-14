require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get notes_create_url
    assert_response :success
  end

  test "should get update" do
    get notes_update_url
    assert_response :success
  end
end
