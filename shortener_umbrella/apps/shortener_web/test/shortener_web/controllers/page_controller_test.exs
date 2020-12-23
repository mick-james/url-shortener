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

  test "GET /?url=#{@url} succeeds on create record", %{conn: conn} do
    Shortener.UrlShortenerMock
    |> expect(:shorten, fn url ->
      assert url == @url
      {:ok, @code}
    end)

    conn = get(conn, "/?url=#{@url}")
    assert html_response(conn, 200) =~ "<p>Your shortened url is: http://localhost:4002/#{@code}</p>"
  end

  test "GET /?url=#{@url} reports an error", %{conn: conn} do
    Shortener.UrlShortenerMock
    |> expect(:shorten, fn url ->
      assert url == @url
      {:error, @error}
    end)

    conn = get(conn, "/?url=#{@url}")
    assert html_response(conn, 200) =~ "<p class=\"alert alert-danger\" role=\"alert\">#{@error}</p>"
  end
end
