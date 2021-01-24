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

  test "GET /<code> with a valid code forwards to a url", %{conn: conn} do
    Shortener.StringShortenerMock
    |> expect(:lengthen, fn code ->
      assert code == @code
      {:ok, @url}
    end)

    conn = get(conn, "/" <> @code)
    assert redirected_to(conn, 302) =~ @url
  end

  test "GET /<code> with an invalid code renders the home page", %{conn: conn} do
    Shortener.StringShortenerMock
    |> expect(:lengthen, fn code ->
      assert code == @code
      {:error, @error}
    end)

    conn = get(conn, "/" <> @code)
    assert get_flash(conn, :error) == @error
    assert redirected_to(conn, 302) =~ "/"
  end

  test "GET /<code> with extra params handles the redirect", %{conn: conn} do
    Shortener.StringShortenerMock
    |> expect(:lengthen, fn code ->
      assert code == @code
      {:ok, @url}
    end)

    conn = get(conn, "/" <> @code <> "?Extradata=43235")
    assert redirected_to(conn, 302) =~ @url
  end
end
