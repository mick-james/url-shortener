defmodule ShortenerWeb.PageController do
  use ShortenerWeb, :controller

  def index(conn, %{"url" => url}) do
    url
    |> Shortener.shorten()
    |> case do
      {:ok, short_string} ->
        IO.inspect short_string
      {:error, reason} ->
        IO.inspect reason
    end
    render(conn, "index.html")
  end

  def index(conn, _params), do: render(conn, "index.html")
  
end
