defmodule Validator do
  @moduledoc """
  A validator module holding common utilities used to
  validate input strings
  """

  @doc ~S"""
  Validates a string as a URL.  The string must be a complete url leading with http|https

  ## Examples

  iex> Validator.validURL?("")
  false

  iex> Validator.validURL?("invalid")
  false

  iex> Validator.validURL?("google")
  false

  iex> Validator.validURL?("google.com")
  false

  iex> Validator.validURL?("www.google.com")
  false

  iex> Validator.validURL?("http://google.com")
  true

  iex> Validator.validURL?("http://goo.gl/ASETGARG")
  true

  iex> Validator.validURL?("https://yahoo.com/search?string=values")
  true

  """
  def validURL?(url) do
    uri = URI.parse(url)
    uri.scheme != nil && uri.host =~ "."
  end
end
