ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Shortener.Repo, :manual)

Mox.defmock(Shortener.StringShortenerMock, for: Shortener.StringShortener)
