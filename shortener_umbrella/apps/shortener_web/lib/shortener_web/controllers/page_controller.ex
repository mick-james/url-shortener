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

  def send_to_url(conn, params = %{"code" => [code]}) do
    code
    |> Shortener.lengthen()
    |> case do
      {:ok, url} ->
        conn
        |> clear_flash()
        |> redirect(external: url)
      {:error, reason} ->
        conn
        |> clear_flash()
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
