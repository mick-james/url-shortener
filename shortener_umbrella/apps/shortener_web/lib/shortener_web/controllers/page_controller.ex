defmodule ShortenerWeb.PageController do
  use ShortenerWeb, :controller

  def index(conn, %{"url" => url}) do
    url
    |> Shortener.shorten()
    |> case do
      {:ok, code} ->
        conn
        |> clear_flash()
        render(conn, "index.html", short: code)
      {:error, reason} ->
        conn
        |> clear_flash()
        |> put_flash(:error, reason)
        |> render("index.html")
    end
  end

  def index(conn, _), do: render(conn, "index.html")
end
