defmodule Shortener do
  @moduledoc """
  Shortener is a String Shortener Application

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  Shorten and persist a string.
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
    if Enum.any?(changeset.errors, &actual_error?/1) do
      {:error, "There was an error trying to shorten that URL"}
    else
      {:ok, changeset.changes.short_code}
    end
  end
  defp handle_insert({:error, _}), do: {:error, "There was a problem talking to the database"}
  
  @doc """
  Lookup the stored string from the short code
  """
  def lengthen(string_to_lengthen) do
    # {:ok, string_to_lengthen}
    {:error, "Error: Not implemented"}
  end

  defp actual_error?({:short_code, {_, [constraint: :unique, constraint_name: _]}}) do
    false
  end
  defp actual_error?(_), do: true

end
