defmodule Shortener.Test do
  use Shortener.DataCase, async: true

  import Shortener.StringShortener, only: [shorten: 1, lengthen: 1]

  @code "MTA0NjExNDAz"
  @value "string_value_here"

  test "lengthen: Missing code returns error" do
    response = lengthen(@code)
    assert {:error, "That short code does not match one of our urls"} == response
  end

  test "lengthen: Preset code returns url" do
    %Shortener.ShortCode{}
    |> Shortener.ShortCode.changeset(%{"short_code" => @code, "value" => @value})
    |> Shortener.Repo.insert!()

    response = lengthen(@code)
    assert {:ok, @value} == response
  end

  test "shorten: Duplicate code returns success" do
    %Shortener.ShortCode{}
    |> Shortener.ShortCode.changeset(%{"short_code" => @code, "value" => @value})
    |> Shortener.Repo.insert!()

    response = shorten(@value)
    assert {:ok, @code} == response
  end

  test "shorten: New code returns success" do
    assert nil == Shortener.Repo.get_by(Shortener.ShortCode, short_code: @code)

    response = shorten(@value)
    assert {:ok, @code} == response

    new_record = Shortener.Repo.get_by(Shortener.ShortCode, short_code: @code)
    assert new_record.short_code == @code
    assert new_record.value == @value

  end

  # Tests etc...
end