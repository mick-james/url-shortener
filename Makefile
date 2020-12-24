.PHONY: $(MAKECMDGOALS)

# `make setup` will be used after cloning or downloading to fulfill
# dependencies, and setup the the project in an initial state.
# This is where you might download rubygems, node_modules, packages,
# compile code, build container images, initialize a database,
# anything else that needs to happen before your server is started
# for the first time
setup:
	cd shortener_umbrella; mix deps.get; mix ecto.create; mix ecto.migrate;
	cd shortener_umbrella/apps/shortener_web/assets; npm install; npm run deploy;
	cd shortener_umbrella; mix do compile, phx.digest;

# `make server` will be used after `make setup` in order to start
# an http server process that listens on any unreserved port
#	of your choice (e.g. 8080). 
server:
	cd shortener_umbrella; mix phx.server

# `make test` will be used after `make setup` in order to run
# your test suite.
test:
	cd shortener_umbrella; mix test