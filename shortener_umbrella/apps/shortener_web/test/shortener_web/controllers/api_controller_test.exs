defmodule ShortenerWeb.ApiControllerTest do
  use ShortenerWeb.ConnCase, async: true

  import Mox

  setup :verify_on_exit!

  @code "MTI2NDQ4MDI"
  @invalid_url "url_value_here"
  @valid_url "https://yahoo.com"
  @error "error_message_here"

  test "POST /api/shorten succeeds on create record", %{conn: conn} do
    Shortener.StringShortenerMock
    |> expect(:shorten, fn url ->
      assert url == @valid_url
      {:ok, @code}
    end)

    conn = post(conn, "/api/shorten", url: @valid_url)

    assert json_response(conn, 201) == %{
             "code" => @code,
             "status" => "ok",
             "url" => @valid_url
           }
  end

  test "POST /api/shorten rejects an empty url", %{conn: conn} do
    conn = post(conn, "/api/shorten", url: "")

    assert json_response(conn, 400) == %{
             "status" => "error",
             "message" => "url is invalid"
           }
  end

  test "POST /api/shorten rejects a missing url", %{conn: conn} do
    conn = post(conn, "/api/shorten")

    assert json_response(conn, 400) == %{
             "status" => "error",
             "message" => "url is missing"
           }
  end

  test "POST /api/shorten reports on internal error", %{conn: conn} do
    Shortener.StringShortenerMock
    |> expect(:shorten, fn url ->
      assert url == @valid_url
      {:error, @error}
    end)

    conn = post(conn, "/api/shorten", url: @valid_url)

    assert json_response(conn, 500) == %{
             "status" => "error",
             "message" => @error
           }
  end
end
