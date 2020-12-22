defmodule Shortener do
  @moduledoc """
  Shortener is a String Shortener Application

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  Shorten and persist a string.
  """
  def shorten(string_to_shorten) do
    # {:ok, string_to_shorten}
    {:error, "Error: Not implemented"}
  end

  def lengthen(string_to_lengthen) do
    # {:ok, string_to_lengthen}
    {:error, "Error: Not implemented"}
  end
end
