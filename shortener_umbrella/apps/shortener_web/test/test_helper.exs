ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Shortener.Repo, :manual)


Mox.defmock(ShortenerMock, for: Shortener)