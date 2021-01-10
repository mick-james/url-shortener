defmodule ShortenerWeb.PageController do
  use ShortenerWeb, :controller

  def url_shortener, do: Application.get_env(:shortener_web, :shortener_api)

  def index(conn, _), do: render(conn, "index.html")

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
