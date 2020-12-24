defmodule ShortenerWeb.PageController do
  use ShortenerWeb, :controller

  def url_shortener, do: Application.get_env(:shortener_web, :shortener_api)

  def index(conn, _), do: render(conn, "index.html")

  def shorten(conn, %{"url" => ""}) do
    conn
    |> put_status(:bad_request)
    |> json(%{"status" => "error", "message" => "url is missing"})
  end

  def shorten(conn, %{"url" => url}) do
    url
    |> url_shortener().shorten()
    |> case do
      {:ok, code} ->
        conn
        |> put_status(:created)
        |> json(%{"status" => "ok", "url" => url, "code" => code})
      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{"status" => "error", "message" => reason})
    end
  end


  def send_to_url(conn, %{"code" => [code]}) do
    code
    |> url_shortener().lengthen()
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
