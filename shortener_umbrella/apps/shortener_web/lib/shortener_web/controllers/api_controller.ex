defmodule ShortenerWeb.ApiController do
  use ShortenerWeb, :controller

  def url_shortener, do: Application.get_env(:shortener_web, :shortener_api)

  def shorten(conn, %{"url" => ""}) do
    conn
    |> put_status(:bad_request)
    |> json(%{"status" => "error", "message" => "url is invalid"})
  end

  def shorten(conn, %{"url" => url}) do
    with {:valid, true} <- {:valid, Validator.validURL?(url)},
         {:ok, code} <- url_shortener().shorten(url) do
      conn
      |> put_status(:created)
      |> json(%{"status" => "ok", "url" => url, "code" => code})
    else
      {:valid, false} ->
        # url failed validation
        conn
        |> put_status(:bad_request)
        |> json(%{"status" => "error", "message" => "Invalid url format"})

      {:error, reason} ->
        # shortener failed or rejected the command
        conn
        |> put_status(:internal_server_error)
        |> json(%{"status" => "error", "message" => reason})
    end
  end

  def shorten(conn, _) do
    conn
    |> put_status(:bad_request)
    |> json(%{"status" => "error", "message" => "url is missing"})
  end
end
