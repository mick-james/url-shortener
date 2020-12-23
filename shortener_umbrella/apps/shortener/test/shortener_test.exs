defmodule Shortener.Test do
  use Shortener.DataCase, async: true

  import Shortener, only: [shorten: 1, lengthen: 1]

  @code "MTI2NDQ4MDI"
  @url "url_value_here"

  test "lengthen: Missing code returns error" do
    response = lengthen(@code)
    assert {:error, "That short code does not match one of our urls"} == response
  end

  test "lengthen: Preset code returns url" do
    %Shortener.Url{}
    |> Shortener.Url.changeset(%{"short_code" => @code, "url" => @url})
    |> Shortener.Repo.insert!()

    response = lengthen(@code)
    assert {:ok, @url} == response
  end

  test "shorten: Duplicate code returns success" do
    %Shortener.Url{}
    |> Shortener.Url.changeset(%{"short_code" => @code, "url" => @url})
    |> Shortener.Repo.insert!()

    response = shorten(@url)
    assert {:ok, @code} == response
  end

  test "shorten: New code returns success" do
    assert nil == Shortener.Repo.get_by(Shortener.Url, short_code: @code)

    response = shorten(@url)
    assert {:ok, @code} == response

    new_record = Shortener.Repo.get_by(Shortener.Url, short_code: @code)
    assert new_record.short_code == @code
    assert new_record.url == @url

  end

  # Tests etc...
end