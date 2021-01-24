# Michaels Url Shortener Submission

## Description

This is my submission for the URL shortener coding challenge.  I completed this using Elixir, the Phoenix Framework, and ES6 Javascript.  I use a postgres database running inside of a docker container to support persistence, though for this submission I do not mount a volume on the container, so it is purged and destroyed when it is stopped, your the reviewers; convenience.

## Running the Submission

The provided Makefile stubs (`setup`, `server`, and `test`) have been completed and work as described.  There is an additional target I added (`cleanup`) that halts the postgres docker container and removes the docker network that supports this deployment.

I developed this on OSX 10.13.6, which requires workarounds for docker functionality.  While I expect Linux, with better support, to work well, this is not tested.  If you are on Windows I'm afraid you are on your own.

To access the submission, you mar run these steps in this order:

1. run `make setup`
1. optionally run `make test` to execute the unit tests included with the Elixir server.
1. run `make server`
1. open 127.0.0.1:4000 in a web browser to interact with the application.
1. Terminate the server instance through the application of `ctrl-c` twice.
1. run `make cleanup` after the server has exited to halt/destroy the docker container and docker network used to support this server.

## Assumptions

1. You have docker installed and functional on your evaluation system.
1. You do not have a postgres server already running on your evaluation system, and port 5432 is available.
1. You do not have a container running on oyur evaluation system that will collide names with the container this submission uses, named `postgres`
1. You do not have a docker network defined on your system that will name-collide with the network used in this submission, named `url_shortener_postgres`

## Notes

- SQL sandbox is used for unit tests against the url shortener functionality
- MOX mocking is used for unit tests against the web interface
- Javascript / ReactJS Module testing is absent; they have only been tested manually.


## Further improvements (given time, motivation, and need)

- Implement a caching strategy, such as `Cachex`, to speed up repeated calls to the same shortened url (and reduce db load)
- Switch the server to a mix release
- Move the unit tests and server run from the host to docker containers
- Migrate to docker-compose or kubernetes
- Add Javascript client-side unit testing, and Client-server integration testing.