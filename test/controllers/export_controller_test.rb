require "test_helper"

class ExportControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get export_index_url
    assert_response :success
  end

  test "should get day" do
    get export_day_url
    assert_response :success
  end

  test "should get week" do
    get export_week_url
    assert_response :success
  end

  test "should get export_day" do
    get export_export_day_url
    assert_response :success
  end

  test "should get export_week" do
    get export_export_week_url
    assert_response :success
  end
end
