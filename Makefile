.PHONY: $(MAKECMDGOALS)

.ONESHELL:

define wait_for_postgres
	docker run --rm --network url_shortener_postgres willwill/wait-for-it postgres:5432 -s -t 20 -- echo "postgres is up"
endef

define start_postgres
	docker network create url_shortener_postgres
	docker run --rm -d --name postgres -p 5432:5432 --network url_shortener_postgres -e POSTGRES_PASSWORD=postgres postgres:9.6.20-alpine
	$(call wait_for_postgres)
endef

define stop_postgres
  -docker stop postgres
	docker network rm url_shortener_postgres
endef

# `make setup` will be used after cloning or downloading to fulfill
# dependencies, and setup the the project in an initial state.
# This is where you might download rubygems, node_modules, packages,
# compile code, build container images, initialize a database,
# anything else that needs to happen before your server is started
# for the first time
setup:
	-$(call start_postgres)
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

# `make cleanup` will halt and destroy any extra databases or services started during setup
cleanup:
	$(call stop_postgres)