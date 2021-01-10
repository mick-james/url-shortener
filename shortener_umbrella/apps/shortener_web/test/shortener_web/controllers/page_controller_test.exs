defmodule ShortenerWeb.PageControllerTest do
  use ShortenerWeb.ConnCase, async: true

  import Mox

  setup :verify_on_exit!

  @code "MTI2NDQ4MDI"
  @url "url_value_here"
  @error "error_message_here"

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Shortener · Phoenix Framework"
  end

  test "POST /api/shorten succeeds on create record", %{conn: conn} do
    Shortener.StringShortenerMock
    |> expect(:shorten, fn url ->
      assert url == @url
      {:ok, @code}
    end)

    conn = post(conn, "/api/shorten", url: @url)
    assert json_response(conn, 201) == %{
      "code" => @code,
      "status" => "ok",
      "url" => @url
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
      assert url == @url
      {:error, @error}
    end)

    conn = post(conn, "/api/shorten", url: @url)
    assert json_response(conn, 500) == %{
      "status" => "error",
      "message" => @error
    }
  end
end
