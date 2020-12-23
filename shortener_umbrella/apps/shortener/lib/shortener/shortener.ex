defmodule Shortener.UrlShortener do
  @moduledoc """
  Shortener is a String Shortener Application
  """
  @callback shorten(String.t) :: {atom, String.t}
  @callback lengthen(String.t) :: {atom, String.t}

  @doc """
  Shorten and persist a url, returning the short code
  """
  def shorten(url) do
    code = encodeUrl(url)
  
    %Shortener.Url{}
    |> Shortener.Url.changeset(%{short_code: code, url: url})
    |> Shortener.Repo.insert()
    |> handle_insert()
  end

  defp encodeUrl(url) do
    url
    |> :erlang.phash2()
    |> Integer.to_string()
    |> Base.url_encode64(padding: false)
  end

  defp handle_insert({:ok, %{short_code: code}}), do: {:ok, code}
  defp handle_insert({:error, changeset = %Ecto.Changeset{}}) do
    if Enum.all?(changeset.errors, &actual_error?/1) do
      {:error, "There was an error trying to shorten that URL"}
    else
      {:ok, changeset.changes.short_code}
    end
  end
  defp handle_insert({:error, _}), do: {:error, "There was a problem talking to the database"}
  
  @doc """
  Lookup the stored url from the short code
  """
  def lengthen(code) do
    Shortener.Url
    |> Shortener.Repo.get_by(short_code: code)
    |> case do
      nil -> {:error, "That short code does not match one of our urls"}

      %Shortener.Url{url: url} -> {:ok, url}
    end
  end

  defp actual_error?({:short_code, {_, [constraint: :unique, constraint_name: _]}}) do
    false
  end
  defp actual_error?(_), do: true

end
